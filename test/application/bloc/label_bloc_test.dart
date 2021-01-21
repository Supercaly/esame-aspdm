import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/domain/repositories/label_repository.dart';
import 'package:aspdm_project/application/bloc/labels_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_failure.dart';

class MockLabelRepository extends Mock implements LabelRepository {}

void main() {
  group("LabelsBloc Tests", () {
    LabelRepository repository;

    setUp(() {
      repository = MockLabelRepository();
    });

    blocTest(
      "emits nothing when created",
      build: () => LabelsBloc(repository),
      expect: [],
    );

    blocTest(
      "emits data on success",
      build: () => LabelsBloc(repository),
      act: (LabelsBloc bloc) {
        when(repository.getLabels())
            .thenAnswer((_) => Future.value(Either.right([])));
        bloc.fetch();
      },
      expect: [
        LabelsState.loading(),
        LabelsState.data([]),
      ],
    );

    blocTest(
      "emits error on error",
      build: () => LabelsBloc(repository),
      act: (LabelsBloc bloc) {
        when(repository.getLabels())
            .thenAnswer((_) => Future.value(Either.left(MockFailure())));
        bloc.fetch();
      },
      expect: [
        LabelsState.loading(),
        LabelsState.error(),
      ],
    );
  });
}
