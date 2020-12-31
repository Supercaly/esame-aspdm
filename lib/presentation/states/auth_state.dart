import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/repositories/auth_repository.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Class containing the authentication state.
class AuthState extends ChangeNotifier {
  AuthRepository _repository;
  User _currentUser;
  bool _isLoading;

  AuthState(this._repository)
      : _currentUser = _repository.lastSignedInUser,
        _isLoading = false;

  /// Returns the current logged in [User]
  User get currentUser => _currentUser;

  /// Returns true if the login is in progress.
  bool get isLoading => _isLoading;

  /// Logs in a new user with given [email] and [password].
  /// Returns `false` if the login fail with an error,
  /// `true` otherwise.
  Future<bool> login(String email, String password) async {
    // Start loading
    _isLoading = true;
    notifyListeners();

    // Try logging in the user with credentials.
    try {
      final newUser = await _repository.login(email, password);
      _currentUser = newUser;
      notifyListeners();
      return true;
    } catch (e) {
      locator<LogService>().error("AuthState.login:", e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logs out the current logged in [User].
  /// After this method call [currentUser] will be `null`.
  Future<void> logout() async {
    locator<LogService>().info("Sign Out user!");
    await _repository.logout();
    _currentUser = null;
    notifyListeners();
  }

  @override
  String toString() => "AuthState {currentUser: $_currentUser}";
}
