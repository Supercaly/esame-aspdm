import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/maybe.dart';
import 'package:aspdm_project/domain/failures/failures.dart';
import 'package:aspdm_project/domain/values/user_values.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Maybe<User> get lastSignedInUser;

  Future<Either<Failure, User>> login(EmailAddress email, Password password);

  Future<Either<Failure, Unit>> logout();
}
