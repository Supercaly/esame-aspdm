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

  LoginBloc({AuthRepository repository})
      : _repository = repository,
        super(LoginState.initial());

  /// Tries to login an user with given [email] and [password].
  Future<void> login(EmailAddress email, Password password) async {
    emit(LoginState.loading());
    final result = await _repository.login(email, password);
    emit(LoginState.result(result));
  }
}

/// Class representing the state of the [LoginBloc].
class LoginState {
  /// Show a loading while the login is in progress
  final bool isLoading;

  /// An option tha represent either a failure or a success during
  /// the login process.
  final Maybe<Either<Failure, User>> authFailureOrSuccessOption;

  const LoginState._(this.isLoading, this.authFailureOrSuccessOption);

  factory LoginState.initial() => LoginState._(false, Maybe.nothing());

  factory LoginState.loading() => LoginState._(true, Maybe.nothing());

  factory LoginState.result(Either<Failure, User> result) =>
      LoginState._(false, Maybe.just(result));
}
