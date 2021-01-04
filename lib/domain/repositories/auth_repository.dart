import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/failures.dart';
import 'package:aspdm_project/core/unit.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Either<Failure, User> get lastSignedInUser;

  Future<Either<Failure, User>> login(String email, String password);

  Future<Either<Failure, Unit>> logout();
}
