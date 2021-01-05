import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/failures.dart';
import 'package:aspdm_project/core/unit.dart';
import 'package:aspdm_project/domain/values/email_address.dart';
import 'package:aspdm_project/domain/values/password.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Either<Failure, User> get lastSignedInUser;

  Future<Either<Failure, User>> login(EmailAddress email, Password password);

  Future<Either<Failure, Unit>> logout();
}
