import 'package:tasky/core/either.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/failures/failures.dart';

abstract class MembersRepository {
  Future<Either<Failure, IList<User>>> getUsers();
}
