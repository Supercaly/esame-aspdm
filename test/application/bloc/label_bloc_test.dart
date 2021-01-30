import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/ilist.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/repositories/label_repository.dart';
import 'package:aspdm_project/application/bloc/labels_bloc.dart';
import 'package:aspdm_project/domain/values/label_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
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
      build: () => LabelsBloc(repository: repository),
      expect: [],
    );

    blocTest(
      "emits data on success",
      build: () => LabelsBloc(repository: repository),
      act: (LabelsBloc bloc) {
        when(repository.getLabels())
            .thenAnswer((_) => Future.value(Either.right(IList.empty())));
        bloc.fetch();
      },
      expect: [
        LabelsState(IList.empty(), IList.empty(), true, false),
        LabelsState(IList.empty(), IList.empty(), false, false),
      ],
    );

    blocTest(
      "emits error on error",
      build: () => LabelsBloc(repository: repository),
      act: (LabelsBloc bloc) {
        when(repository.getLabels())
            .thenAnswer((_) => Future.value(Either.left(MockFailure())));
        bloc.fetch();
      },
      expect: [
        LabelsState(IList.empty(), IList.empty(), true, false),
        LabelsState(IList.empty(), IList.empty(), false, true),
      ],
    );

    blocTest(
      "emits on select",
      build: () => LabelsBloc(repository: repository),
      act: (LabelsBloc bloc) async {
        when(repository.getLabels()).thenAnswer((_) async => Either.right(
              IList.from([
                Label(UniqueId("label1"), Colors.red, LabelName("Label 1")),
                Label(UniqueId("label2"), Colors.green, LabelName("Label 2")),
                Label(UniqueId("label3"), Colors.blue, LabelName("Label 3")),
              ]),
            ));
        await bloc.fetch();
        bloc.selectLabel(
          Label(UniqueId("label2"), Colors.green, LabelName("Label 2")),
        );
      },
      expect: [
        LabelsState(IList.empty(), IList.empty(), true, false),
        LabelsState(
            IList.empty(),
            IList.from([
              Label(UniqueId("label1"), Colors.red, LabelName("Label 1")),
              Label(UniqueId("label2"), Colors.green, LabelName("Label 2")),
              Label(UniqueId("label3"), Colors.blue, LabelName("Label 3")),
            ]),
            false,
            false),
        LabelsState(
            IList.from([
              Label(UniqueId("label2"), Colors.green, LabelName("Label 2"))
            ]),
            IList.from([
              Label(UniqueId("label1"), Colors.red, LabelName("Label 1")),
              Label(UniqueId("label2"), Colors.green, LabelName("Label 2")),
              Label(UniqueId("label3"), Colors.blue, LabelName("Label 3")),
            ]),
            false,
            false),
      ],
    );

    blocTest(
      "emits on deselect",
      build: () => LabelsBloc(
        initialValue: IList.from([
          Label(UniqueId("label1"), Colors.red, LabelName("Label 1")),
          Label(UniqueId("label2"), Colors.green, LabelName("Label 2")),
          Label(UniqueId("label3"), Colors.blue, LabelName("Label 3")),
        ]),
        repository: repository,
      ),
      act: (LabelsBloc bloc) {
        bloc.deselectLabel(
          Label(UniqueId("label2"), Colors.green, LabelName("Label 2")),
        );
      },
      expect: [
        LabelsState(
            IList.from([
              Label(UniqueId("label1"), Colors.red, LabelName("Label 1")),
              Label(UniqueId("label3"), Colors.blue, LabelName("Label 3")),
            ]),
            IList.empty(),
            false,
            false),
      ],
    );
  });
}
