// @dart=2.9
import 'package:tasky/core/either.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/failures/failures.dart';
import 'package:tasky/domain/values/user_values.dart';
import 'package:tasky/locator.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/repositories/auth_repository.dart';
import 'package:tasky/services/log_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Class containing the authentication state.
class AuthState extends ChangeNotifier {
  AuthRepository _repository;
  Maybe<User> _currentUser;
  bool _isLoading;

  AuthState(this._repository)
      : _currentUser = _repository.lastSignedInUser,
        _isLoading = false;

  /// Returns the current logged in [User]
  Maybe<User> get currentUser => _currentUser;

  /// Returns true if the login is in progress.
  bool get isLoading => _isLoading;

  /// Logs in a new user with given [email] and [password].
  /// Returns `false` if the login fail with an error,
  /// `true` otherwise.
  Future<Either<Failure, Unit>> login(
      EmailAddress email, Password password) async {
    // Start loading
    _isLoading = true;
    notifyListeners();

    // Log in the user with credentials.
    return (await _repository.login(email, password)).fold(
      (left) {
        locator<LogService>().error("AuthState.login: ", left);
        _currentUser = Maybe.nothing();
        _isLoading = false;
        notifyListeners();
        return Either<Failure, Unit>.left(left);
      },
      (right) {
        _currentUser = Maybe.just(right);
        _isLoading = false;
        notifyListeners();
        return Either<Failure, Unit>.right(const Unit());
      },
    );
  }

  /// Logs out the current logged in [User].
  /// After this method call [currentUser] will be `null`.
  Future<Either<Failure, Unit>> logout() async {
    locator<LogService>().info("Sign Out user!");
    await _repository.logout();
    _currentUser = Maybe.nothing();
    notifyListeners();
    return Either.right(const Unit());
  }

  @override
  String toString() => "AuthState {currentUser: $_currentUser}";
}
