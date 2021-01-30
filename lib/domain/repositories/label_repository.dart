import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/ilist.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/failures/failures.dart';

abstract class LabelRepository {
  Future<Either<Failure, IList<Label>>> getLabels();
}
