import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/domain/failures/failures.dart';
import 'package:aspdm_project/domain/values/user_values.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Either<Failure, User> get lastSignedInUser;

  Future<Either<Failure, User>> login(EmailAddress email, Password password);

  Future<Either<Failure, Unit>> logout();
}
