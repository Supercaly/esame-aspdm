import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/failures.dart';
import 'package:aspdm_project/core/unit.dart';
import 'package:aspdm_project/domain/values/email_address.dart';
import 'package:aspdm_project/domain/values/password.dart';
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
      : _currentUser = _repository.lastSignedInUser.fold(
          (_) => null,
          (right) => right,
        ),
        _isLoading = false;

  /// Returns the current logged in [User]
  User get currentUser => _currentUser;

  /// Returns true if the login is in progress.
  bool get isLoading => _isLoading;

  /// Logs in a new user with given [email] and [password].
  /// Returns `false` if the login fail with an error,
  /// `true` otherwise.
  Future<Either<Failure, Unit>> login(EmailAddress email, Password password) async {
    // Start loading
    _isLoading = true;
    notifyListeners();

    // Log in the user with credentials.
    return (await _repository.login(email, password)).map(
      (left) {
        locator<LogService>().error("AuthState.login: ", left);
        _isLoading = false;
        notifyListeners();
        return left;
      },
      (right) {
        _currentUser = right;
        _isLoading = false;
        notifyListeners();
        return const Unit();
      },
    );
  }

  /// Logs out the current logged in [User].
  /// After this method call [currentUser] will be `null`.
  Future<Either<Failure, Unit>> logout() async {
    locator<LogService>().info("Sign Out user!");
    await _repository.logout();
    _currentUser = null;
    notifyListeners();
    return Either.right(const Unit());
  }

  @override
  String toString() => "AuthState {currentUser: $_currentUser}";
}
