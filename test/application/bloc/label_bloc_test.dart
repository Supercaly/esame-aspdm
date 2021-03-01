import 'package:tasky/core/either.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/label.dart';
import 'package:tasky/domain/repositories/label_repository.dart';
import 'package:tasky/application/bloc/labels_bloc.dart';
import 'package:tasky/domain/values/label_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
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
      build: () => LabelsBloc(initialValue: null, repository: repository),
      expect: () => [],
    );

    blocTest(
      "emits data on success",
      build: () => LabelsBloc(initialValue: null, repository: repository),
      act: (LabelsBloc bloc) {
        when(repository.getLabels())
            .thenAnswer((_) => Future.value(Either.right(IList.empty())));
        bloc.fetch();
      },
      expect: () => [
        LabelsState(IList.empty(), IList.empty(), true, false),
        LabelsState(IList.empty(), IList.empty(), false, false),
      ],
    );

    blocTest(
      "emits error on error",
      build: () => LabelsBloc(initialValue: null, repository: repository),
      act: (LabelsBloc bloc) {
        when(repository.getLabels())
            .thenAnswer((_) => Future.value(Either.left(MockFailure())));
        bloc.fetch();
      },
      expect: () => [
        LabelsState(IList.empty(), IList.empty(), true, false),
        LabelsState(IList.empty(), IList.empty(), false, true),
      ],
    );

    blocTest(
      "emits on select",
      build: () => LabelsBloc(initialValue: null, repository: repository),
      act: (LabelsBloc bloc) async {
        when(repository.getLabels()).thenAnswer((_) async => Either.right(
              IList.from([
                Label.test(
                  id: UniqueId("label1"),
                  color: LabelColor(Colors.red),
                  label: LabelName("Label 1"),
                ),
                Label.test(
                  id: UniqueId("label2"),
                  color: LabelColor(Colors.green),
                  label: LabelName("Label 2"),
                ),
                Label.test(
                  id: UniqueId("label3"),
                  color: LabelColor(Colors.blue),
                  label: LabelName("Label 3"),
                ),
              ]),
            ));
        await bloc.fetch();
        bloc.selectLabel(
          Label.test(
            id: UniqueId("label2"),
            color: LabelColor(Colors.green),
            label: LabelName("Label 2"),
          ),
        );
      },
      expect: () => [
        LabelsState(IList.empty(), IList.empty(), true, false),
        LabelsState(
            IList.empty(),
            IList.from([
              Label.test(
                id: UniqueId("label1"),
                color: LabelColor(Colors.red),
                label: LabelName("Label 1"),
              ),
              Label.test(
                id: UniqueId("label2"),
                color: LabelColor(Colors.green),
                label: LabelName("Label 2"),
              ),
              Label.test(
                id: UniqueId("label3"),
                color: LabelColor(Colors.blue),
                label: LabelName("Label 3"),
              ),
            ]),
            false,
            false),
        LabelsState(
            IList.from([
              Label.test(
                id: UniqueId("label2"),
                color: LabelColor(Colors.green),
                label: LabelName("Label 2"),
              )
            ]),
            IList.from([
              Label.test(
                id: UniqueId("label1"),
                color: LabelColor(Colors.red),
                label: LabelName("Label 1"),
              ),
              Label.test(
                id: UniqueId("label2"),
                color: LabelColor(Colors.green),
                label: LabelName("Label 2"),
              ),
              Label.test(
                id: UniqueId("label3"),
                color: LabelColor(Colors.blue),
                label: LabelName("Label 3"),
              ),
            ]),
            false,
            false),
      ],
    );

    blocTest(
      "emits on deselect",
      build: () => LabelsBloc(
        initialValue: IList.from([
          Label.test(
            id: UniqueId("label1"),
            color: LabelColor(Colors.red),
            label: LabelName("Label 1"),
          ),
          Label.test(
            id: UniqueId("label2"),
            color: LabelColor(Colors.green),
            label: LabelName("Label 2"),
          ),
          Label.test(
            id: UniqueId("label3"),
            color: LabelColor(Colors.blue),
            label: LabelName("Label 3"),
          ),
        ]),
        repository: repository,
      ),
      act: (LabelsBloc bloc) {
        bloc.deselectLabel(
          Label.test(
            id: UniqueId("label2"),
            color: LabelColor(Colors.green),
            label: LabelName("Label 2"),
          ),
        );
      },
      expect: () => [
        LabelsState(
            IList.from([
              Label.test(
                id: UniqueId("label1"),
                color: LabelColor(Colors.red),
                label: LabelName("Label 1"),
              ),
              Label.test(
                id: UniqueId("label3"),
                color: LabelColor(Colors.blue),
                label: LabelName("Label 3"),
              ),
            ]),
            IList.empty(),
            false,
            false),
      ],
    );
  });
}
