import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/model/user.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/services/preference_service.dart';
import 'package:flutter/foundation.dart';

/// Class containing the authentication state.
class AuthState extends ChangeNotifier {
  User _currentUser;

  AuthState(this._currentUser);

  /// Returns the current logged in [User]
  User get currentUser => _currentUser;

  /// Logs in a new user with given [email] and [password].
  /// Returns `false` if the login fail with an error,
  /// `true` otherwise.
  Future<bool> login(String email, String password) async {
    try {
      final newUser = User("mock_id", "Mock User", email);
      if (_currentUser != newUser) {
        _currentUser = newUser;
        locator<PreferenceService>().storeSignedInUser(newUser);
        notifyListeners();
      }
      return true;
    } catch (e) {
      locator<LogService>().error("AuthState.login:", e);
      return false;
    }
  }

  /// Logs out the current logged in [User].
  /// After this method call [currentUser] will be `null`.
  Future<void> logout() async {
    locator<LogService>().info("Sign Out user!");
    locator<PreferenceService>().storeSignedInUser(null);
    _currentUser = null;
    notifyListeners();
  }

  @override
  String toString() => "AuthState {currentUser: $_currentUser}";
}
