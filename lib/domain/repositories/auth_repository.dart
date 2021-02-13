import 'package:tasky/core/either.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/failures/failures.dart';
import 'package:tasky/domain/values/user_values.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Maybe<User> get lastSignedInUser;

  Future<Either<Failure, User>> login(EmailAddress email, Password password);

  Future<Either<Failure, Unit>> logout();
}
