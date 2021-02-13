import 'package:tasky/core/either.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/label.dart';
import 'package:tasky/domain/failures/failures.dart';

abstract class LabelRepository {
  Future<Either<Failure, IList<Label>>> getLabels();
}
