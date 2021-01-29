import 'package:aspdm_project/application/bloc/task_form_bloc.dart';
import 'package:aspdm_project/core/ilist.dart';
import 'package:aspdm_project/core/maybe.dart';
import 'package:aspdm_project/domain/entities/checklist.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/failures/failures.dart';
import 'package:aspdm_project/domain/repositories/task_form_repository.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/domain/values/user_values.dart';
import 'package:aspdm_project/presentation/misc/checklist_primitive.dart';
import 'package:aspdm_project/presentation/misc/task_primitive.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:aspdm_project/core/either.dart';

import '../../mocks/mock_failure.dart';

class MockTaskFormRepository extends Mock implements TaskFormRepository {}

void main() {
  group("TaskFormBloc tests", () {
    TaskFormRepository repository;

    setUp(() {
      repository = MockTaskFormRepository();
    });

    blocTest(
      "emit nothing when created",
      build: () => TaskFormBloc(
        oldTask: Maybe.nothing(),
        repository: repository,
      ),
      expect: [],
    );

    blocTest(
      "title changed emit state",
      build: () => TaskFormBloc(
        oldTask: Maybe.nothing(),
        repository: repository,
      ),
      act: (TaskFormBloc cubit) => cubit.titleChanged("new title"),
      expect: [
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty().copyWith(title: "new title"),
          mode: TaskFormMode.creating,
          isSaving: false,
          saved: false,
          hasError: false,
        ),
      ],
    );

    blocTest(
      "description changed emit state",
      build: () => TaskFormBloc(
        oldTask: Maybe.nothing(),
        repository: repository,
      ),
      act: (TaskFormBloc cubit) => cubit.descriptionChanged("new description"),
      expect: [
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty().copyWith(
            description: "new description",
          ),
          mode: TaskFormMode.creating,
          isSaving: false,
          saved: false,
          hasError: false,
        ),
      ],
    );

    blocTest(
      "expire date changed emit state",
      build: () => TaskFormBloc(
        oldTask: Maybe.nothing(),
        repository: repository,
      ),
      act: (TaskFormBloc cubit) {
        cubit.dateChanged(Maybe.just(DateTime.fromMillisecondsSinceEpoch(0)));
        cubit.dateChanged(Maybe.nothing());
      },
      expect: [
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty().copyWith(
            expireDate: Maybe.just(DateTime.fromMillisecondsSinceEpoch(0)),
          ),
          mode: TaskFormMode.creating,
          isSaving: false,
          saved: false,
          hasError: false,
        ),
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty().copyWith(
            expireDate: Maybe.nothing(),
          ),
          mode: TaskFormMode.creating,
          isSaving: false,
          saved: false,
          hasError: false,
        ),
      ],
    );

    blocTest(
      "members changed emit state",
      build: () => TaskFormBloc(
        oldTask: Maybe.nothing(),
        repository: repository,
      ),
      act: (TaskFormBloc cubit) {
        cubit.membersChanged(IList.from([
          User(
            UniqueId("user1"),
            UserName("User 1"),
            EmailAddress("user1@email.com"),
            null,
          ),
          User(
            UniqueId("user2"),
            UserName("User 2"),
            EmailAddress("user2@email.com"),
            null,
          ),
        ]));
        cubit.membersChanged(IList.empty());
      },
      expect: [
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty().copyWith(
            members: IList.from([
              User(
                UniqueId("user1"),
                UserName("User 1"),
                EmailAddress("user1@email.com"),
                null,
              ),
              User(
                UniqueId("user2"),
                UserName("User 2"),
                EmailAddress("user2@email.com"),
                null,
              ),
            ]),
          ),
          mode: TaskFormMode.creating,
          saved: false,
          isSaving: false,
          hasError: false,
        ),
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty().copyWith(members: IList.empty()),
          mode: TaskFormMode.creating,
          saved: false,
          isSaving: false,
          hasError: false,
        ),
      ],
    );

    blocTest(
      "labels changed emit state",
      build: () => TaskFormBloc(
        oldTask: Maybe.nothing(),
        repository: repository,
      ),
      act: (TaskFormBloc cubit) {
        cubit.labelsChanged(IList.from([
          Label(
            UniqueId("label1"),
            Colors.red,
            "label 1",
          ),
          Label(
            UniqueId("label2"),
            Colors.red,
            "label 2",
          ),
        ]));
        cubit.labelsChanged(IList.empty());
      },
      expect: [
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty().copyWith(
            labels: IList.from([
              Label(
                UniqueId("label1"),
                Colors.red,
                "label 1",
              ),
              Label(
                UniqueId("label2"),
                Colors.red,
                "label 2",
              ),
            ]),
          ),
          mode: TaskFormMode.creating,
          isSaving: false,
          saved: false,
          hasError: false,
        ),
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty().copyWith(labels: IList.empty()),
          mode: TaskFormMode.creating,
          isSaving: false,
          saved: false,
          hasError: false,
        ),
      ],
    );

    blocTest(
      "add checklist emit state",
      build: () => TaskFormBloc(
        oldTask: Maybe.just(Task(
          UniqueId.empty(),
          TaskTitle.empty(),
          TaskDescription.empty(),
          null,
          null,
          null,
          null,
          IList.from([
            Checklist(
              UniqueId("checklist_id"),
              ChecklistTitle("Checklist 1"),
              IList.from([
                ChecklistItem(
                  UniqueId("item_id"),
                  ItemText("item 1"),
                  Toggle(false),
                )
              ]),
            )
          ]),
          null,
          Toggle(false),
          null,
        )),
        repository: repository,
      ),
      act: (TaskFormBloc cubit) {
        cubit.addChecklist(ChecklistPrimitive(
          title: "Checklist 2",
          items: IList.from([ItemText("item 2")]),
        ));
      },
      expect: [
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty().copyWith(
            description: "",
            checklists: IList.from([
              ChecklistPrimitive(
                title: "Checklist 1",
                items: IList.from([ItemText("item 1")]),
              ),
              ChecklistPrimitive(
                title: "Checklist 2",
                items: IList.from([ItemText("item 2")]),
              ),
            ]),
          ),
          mode: TaskFormMode.editing,
          saved: false,
          isSaving: false,
          hasError: false,
        ),
      ],
    );

    blocTest(
      "remove checklist emit state",
      build: () => TaskFormBloc(
        oldTask: Maybe.just(Task(
          UniqueId.empty(),
          TaskTitle.empty(),
          TaskDescription.empty(),
          null,
          null,
          null,
          null,
          IList.from([
            Checklist(
              UniqueId("checklist_1"),
              ChecklistTitle("Checklist 1"),
              IList.from([
                ChecklistItem(
                  UniqueId("item_id"),
                  ItemText("item 1"),
                  Toggle(false),
                )
              ]),
            ),
            Checklist(
              UniqueId("checklist_2"),
              ChecklistTitle("Checklist 2"),
              IList.from([
                ChecklistItem(
                  UniqueId("item_id"),
                  ItemText("item 1"),
                  Toggle(false),
                )
              ]),
            ),
          ]),
          null,
          Toggle(false),
          null,
        )),
        repository: repository,
      ),
      act: (TaskFormBloc cubit) {
        cubit.removeChecklist(ChecklistPrimitive(
          title: "Checklist 1",
          items: IList.from([ItemText("item 1")]),
        ));
        cubit.removeChecklist(ChecklistPrimitive(
          title: "Checklist 2",
          items: IList.from([ItemText("item 1")]),
        ));
      },
      expect: [
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty().copyWith(
            checklists: IList.from([
              ChecklistPrimitive(
                title: "Checklist 2",
                items: IList.from([ItemText("item 1")]),
              ),
            ]),
          ),
          mode: TaskFormMode.editing,
          isSaving: false,
          saved: false,
          hasError: false,
        ),
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty().copyWith(
            checklists: IList.empty(),
          ),
          mode: TaskFormMode.editing,
          isSaving: false,
          saved: false,
          hasError: false,
        ),
      ],
    );

    blocTest(
      "edit checklist emit state",
      build: () => TaskFormBloc(
          oldTask: Maybe.just(Task(
            UniqueId.empty(),
            TaskTitle.empty(),
            TaskDescription.empty(),
            null,
            null,
            null,
            null,
            IList.from([
              Checklist(
                UniqueId("checklist_1"),
                ChecklistTitle("Checklist 1"),
                IList.from([
                  ChecklistItem(
                    UniqueId("item_id"),
                    ItemText("item 1"),
                    Toggle(false),
                  )
                ]),
              ),
              Checklist(
                UniqueId("checklist_2"),
                ChecklistTitle("Checklist 2"),
                IList.from([
                  ChecklistItem(
                    UniqueId("item_id"),
                    ItemText("item 1"),
                    Toggle(false),
                  )
                ]),
              ),
            ]),
            null,
            Toggle(false),
            null,
          )),
          repository: repository),
      act: (TaskFormBloc cubit) {
        cubit.editChecklist(
            ChecklistPrimitive(
              title: "Checklist 1",
              items: IList.from([ItemText("item 1")]),
            ),
            ChecklistPrimitive(
              title: "Checklist 1 (edited)",
              items: IList.from([
                ItemText("item 1"),
                ItemText("item 2"),
              ]),
            ));
      },
      expect: [
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty().copyWith(
            checklists: IList.from([
              ChecklistPrimitive(
                title: "Checklist 1 (edited)",
                items: IList.from([
                  ItemText("item 1"),
                  ItemText("item 2"),
                ]),
              ),
              ChecklistPrimitive(
                title: "Checklist 2",
                items: IList.from([ItemText("item 1")]),
              ),
            ]),
          ),
          mode: TaskFormMode.editing,
          isSaving: false,
          saved: false,
          hasError: false,
        ),
      ],
    );

    blocTest(
      "save emit success state when in creating mode",
      build: () => TaskFormBloc(
        oldTask: Maybe.nothing(),
        repository: repository,
      ),
      act: (TaskFormBloc cubit) {
        when(repository.saveNewTask(any, any))
            .thenAnswer((_) async => Either<Failure, Unit>.right(const Unit()));
        cubit.saveTask(UniqueId("mock_id"));
      },
      verify: (cubit) => verify(repository.saveNewTask(any, any)).called(1),
      expect: [
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty(),
          mode: TaskFormMode.creating,
          isSaving: true,
          saved: false,
          hasError: false,
        ),
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty(),
          mode: TaskFormMode.creating,
          isSaving: false,
          saved: true,
          hasError: false,
        ),
      ],
    );

    blocTest(
      "save emit error state when in creating mode",
      build: () => TaskFormBloc(
        oldTask: Maybe.nothing(),
        repository: repository,
      ),
      act: (TaskFormBloc cubit) {
        when(repository.saveNewTask(any, any))
            .thenAnswer((_) async => Either<Failure, Unit>.left(MockFailure()));
        cubit.saveTask(UniqueId("mock_id"));
      },
      verify: (cubit) => verify(repository.saveNewTask(any, any)).called(1),
      expect: [
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty(),
          mode: TaskFormMode.creating,
          isSaving: true,
          saved: false,
          hasError: false,
        ),
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty(),
          mode: TaskFormMode.creating,
          isSaving: false,
          saved: false,
          hasError: true,
        ),
      ],
    );

    blocTest(
      "save emit success state when in editing mode",
      build: () => TaskFormBloc(
        oldTask: Maybe.just(Task(
          UniqueId.empty(),
          TaskTitle.empty(),
          TaskDescription.empty(),
          null,
          null,
          null,
          null,
          IList.empty(),
          null,
          Toggle(false),
          null,
        )),
        repository: repository,
      ),
      act: (TaskFormBloc cubit) {
        when(repository.updateTask(any, any))
            .thenAnswer((_) async => Either<Failure, Unit>.right(const Unit()));
        cubit.saveTask(UniqueId("mock_id"));
      },
      verify: (cubit) => verify(repository.updateTask(any, any)).called(1),
      expect: [
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty(),
          mode: TaskFormMode.editing,
          isSaving: true,
          saved: false,
          hasError: false,
        ),
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty(),
          mode: TaskFormMode.editing,
          isSaving: false,
          saved: true,
          hasError: false,
        ),
      ],
    );

    blocTest(
      "save emit error state when in editing mode",
      build: () => TaskFormBloc(
        oldTask: Maybe.just(Task(
          UniqueId.empty(),
          TaskTitle.empty(),
          TaskDescription.empty(),
          null,
          null,
          null,
          null,
          IList.empty(),
          null,
          Toggle(false),
          null,
        )),
        repository: repository,
      ),
      act: (TaskFormBloc cubit) {
        when(repository.updateTask(any, any))
            .thenAnswer((_) async => Either<Failure, Unit>.left(MockFailure()));
        cubit.saveTask(UniqueId("mock_id"));
      },
      verify: (cubit) => verify(repository.updateTask(any, any)).called(1),
      expect: [
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty(),
          mode: TaskFormMode.editing,
          isSaving: true,
          saved: false,
          hasError: false,
        ),
        TaskFormState(
          taskPrimitive: TaskPrimitive.empty(),
          mode: TaskFormMode.editing,
          isSaving: false,
          saved: false,
          hasError: true,
        ),
      ],
    );
  });
}
