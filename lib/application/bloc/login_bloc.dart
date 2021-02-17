import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/failures/failures.dart';
import 'package:tasky/domain/repositories/auth_repository.dart';
import 'package:tasky/domain/values/user_values.dart';
import 'package:tasky/core/either.dart';

/// Class that manage the state of the login page.
class LoginBloc extends Cubit<LoginState> {
  final AuthRepository _repository;

  LoginBloc({@required AuthRepository repository})
      : _repository = repository,
        super(LoginState(false, Maybe.nothing()));

  /// Tries to login an user with given [email] and [password].
  Future<void> login(EmailAddress email, Password password) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.login(email, password);
    emit(state.copyWith(
      isLoading: false,
      authFailureOrSuccessOption: Maybe.just(result),
    ));
  }
}

/// Class representing the state of the [LoginBloc].
class LoginState extends Equatable {
  /// Show a loading while the login is in progress
  final bool isLoading;

  /// An option tha represent either a failure or a success during
  /// the login process.
  final Maybe<Either<Failure, User>> authFailureOrSuccessOption;

  const LoginState(this.isLoading, this.authFailureOrSuccessOption);

  LoginState copyWith({
    bool isLoading,
    Maybe<Either<Failure, User>> authFailureOrSuccessOption,
  }) =>
      LoginState(
        isLoading ?? this.isLoading,
        authFailureOrSuccessOption ?? this.authFailureOrSuccessOption,
      );

  @override
  List<Object> get props => [isLoading, authFailureOrSuccessOption];
}
