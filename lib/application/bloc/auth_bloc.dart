import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/repositories/auth_repository.dart';

part 'auth_bloc.freezed.dart';

/// Class used to manage the current logged in user.
class AuthBloc extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthBloc({AuthRepository repository})
      : _repository = repository,
        super(AuthState.initial(Maybe.nothing()));

  /// Checks the currently logged in user.
  Future<void> checkAuth() async {
    (await _repository.getSignedInUser()).fold(
      () => emit(AuthState.unauthenticated(Maybe.nothing())),
      (value) => emit(AuthState.authenticated(Maybe.just(value))),
    );
  }

  /// Logs out the current user resulting in an
  /// unauthenticated state after this.
  Future<void> logOut() async {
    await _repository.logout();
    emit(AuthState.unauthenticated(Maybe.nothing()));
  }
}

/// Class representing the state of the [AuthBloc].
/// This class is a union of three types:
/// - initial = we don't know the state of the user
/// - authenticated = the user is logged in
/// - unauthenticated = the user is not logged in
@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.initial(Maybe<User> user) = _Initial;

  const factory AuthState.authenticated(Maybe<User> user) = _Authenticated;

  const factory AuthState.unauthenticated(Maybe<User> user) = _Unauthenticated;
}
