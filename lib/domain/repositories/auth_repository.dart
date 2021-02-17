import 'package:tasky/core/either.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/failures/failures.dart';
import 'package:tasky/domain/values/user_values.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Future<Maybe<User>> getSignedInUser();

  Future<Either<Failure, User>> login(EmailAddress email, Password password);

  Future<void> logout();
}
