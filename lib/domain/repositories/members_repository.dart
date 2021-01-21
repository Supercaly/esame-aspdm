import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/failures/failures.dart';

abstract class MembersRepository {
  Future<Either<Failure, List<User>>> getUsers();
}
