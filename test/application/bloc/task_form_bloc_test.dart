import 'package:aspdm_project/application/bloc/task_form_bloc.dart';
import 'package:aspdm_project/core/maybe.dart';
import 'package:aspdm_project/domain/entities/checklist.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/domain/values/user_values.dart';
import 'package:aspdm_project/presentation/misc/checklist_primitive.dart';
import 'package:aspdm_project/presentation/misc/task_primitive.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("TaskFormBloc tests", () {
    blocTest(
      "emit nothing when created",
      build: () => TaskFormBloc(Maybe.nothing()),
      expect: [],
    );

    blocTest(
      "title changed emit state",
      build: () => TaskFormBloc(Maybe.nothing()),
      act: (TaskFormBloc cubit) => cubit.titleChanged("new title"),
      expect: [
        TaskFormState(
          TaskPrimitive.empty().copyWith(title: "new title"),
          false,
          false,
        ),
      ],
    );

    blocTest(
      "description changed emit state",
      build: () => TaskFormBloc(Maybe.nothing()),
      act: (TaskFormBloc cubit) => cubit.descriptionChanged("new description"),
      expect: [
        TaskFormState(
          TaskPrimitive.empty().copyWith(
            description: "new description",
          ),
          false,
          false,
        ),
      ],
    );

    blocTest(
      "expire date changed emit state",
      build: () => TaskFormBloc(Maybe.nothing()),
      act: (TaskFormBloc cubit) {
        cubit.dateChanged(Maybe.just(DateTime.fromMillisecondsSinceEpoch(0)));
        cubit.dateChanged(Maybe.nothing());
      },
      expect: [
        TaskFormState(
          TaskPrimitive.empty().copyWith(
            expireDate: Maybe.just(DateTime.fromMillisecondsSinceEpoch(0)),
          ),
          false,
          false,
        ),
        TaskFormState(
          TaskPrimitive.empty().copyWith(
            expireDate: Maybe.nothing(),
          ),
          false,
          false,
        ),
      ],
    );

    blocTest(
      "members changed emit state",
      build: () => TaskFormBloc(Maybe.nothing()),
      act: (TaskFormBloc cubit) {
        cubit.membersChanged([
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
        ]);
        cubit.membersChanged([]);
      },
      expect: [
        TaskFormState(
          TaskPrimitive.empty().copyWith(
            members: [
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
            ],
          ),
          false,
          false,
        ),
        TaskFormState(
          TaskPrimitive.empty().copyWith(members: []),
          false,
          false,
        ),
      ],
    );

    blocTest(
      "labels changed emit state",
      build: () => TaskFormBloc(Maybe.nothing()),
      act: (TaskFormBloc cubit) {
        cubit.labelsChanged([
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
        ]);
        cubit.labelsChanged([]);
      },
      expect: [
        TaskFormState(
          TaskPrimitive.empty().copyWith(
            labels: [
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
            ],
          ),
          false,
          false,
        ),
        TaskFormState(
          TaskPrimitive.empty().copyWith(labels: []),
          false,
          false,
        ),
      ],
    );

    blocTest(
      "add checklist emit state",
      build: () => TaskFormBloc(Maybe.just(
        Task(
          UniqueId.empty(),
          TaskTitle.empty(),
          TaskDescription.empty(),
          null,
          null,
          null,
          null,
          [
            Checklist(
              UniqueId("checklist_id"),
              ChecklistTitle("Checklist 1"),
              [
                ChecklistItem(
                  UniqueId("item_id"),
                  ItemText("item 1"),
                  Toggle(false),
                )
              ],
            )
          ],
          null,
          Toggle(false),
          null,
        ),
      )),
      act: (TaskFormBloc cubit) {
        cubit.addChecklist(ChecklistPrimitive.empty());
      },
      expect: [
        TaskFormState(
          TaskPrimitive.empty().copyWith(
            description: "",
            checklists: [
              ChecklistPrimitive(
                title: "Checklist 1",
                items: [ItemText("item 1")],
              ),
              ChecklistPrimitive.empty(),
            ],
          ),
          false,
          false,
        ),
      ],
    );

    blocTest(
      "remove checklist emit state",
      build: () => TaskFormBloc(Maybe.just(
        Task(
          UniqueId.empty(),
          TaskTitle.empty(),
          TaskDescription.empty(),
          null,
          null,
          null,
          null,
          [
            Checklist(
              UniqueId("checklist_1"),
              ChecklistTitle("Checklist 1"),
              [
                ChecklistItem(
                  UniqueId("item_id"),
                  ItemText("item 1"),
                  Toggle(false),
                )
              ],
            ),
            Checklist(
              UniqueId("checklist_2"),
              ChecklistTitle("Checklist 2"),
              [
                ChecklistItem(
                  UniqueId("item_id"),
                  ItemText("item 1"),
                  Toggle(false),
                )
              ],
            ),
          ],
          null,
          Toggle(false),
          null,
        ),
      )),
      act: (TaskFormBloc cubit) {
        cubit.removeChecklist(ChecklistPrimitive(
          title: "Checklist 1",
          items: [ItemText("item 1")],
        ));
        cubit.removeChecklist(ChecklistPrimitive(
          title: "Checklist 2",
          items: [ItemText("item 1")],
        ));
      },
      expect: [
        TaskFormState(
          TaskPrimitive.empty().copyWith(
            description: "",
            checklists: [
              ChecklistPrimitive(
                title: "Checklist 2",
                items: [ItemText("item 1")],
              ),
            ],
          ),
          false,
          false,
        ),
        TaskFormState(
          TaskPrimitive.empty().copyWith(
            description: "",
            checklists: [],
          ),
          false,
          false,
        ),
      ],
    );

    blocTest(
      "edit checklist emit state",
      build: () => TaskFormBloc(Maybe.just(
        Task(
          UniqueId.empty(),
          TaskTitle.empty(),
          TaskDescription.empty(),
          null,
          null,
          null,
          null,
          [
            Checklist(
              UniqueId("checklist_1"),
              ChecklistTitle("Checklist 1"),
              [
                ChecklistItem(
                  UniqueId("item_id"),
                  ItemText("item 1"),
                  Toggle(false),
                )
              ],
            ),
            Checklist(
              UniqueId("checklist_2"),
              ChecklistTitle("Checklist 2"),
              [
                ChecklistItem(
                  UniqueId("item_id"),
                  ItemText("item 1"),
                  Toggle(false),
                )
              ],
            ),
          ],
          null,
          Toggle(false),
          null,
        ),
      )),
      act: (TaskFormBloc cubit) {
        cubit.editChecklist(
            ChecklistPrimitive(
              title: "Checklist 1",
              items: [ItemText("item 1")],
            ),
            ChecklistPrimitive(
              title: "Checklist 1 (edited)",
              items: [
                ItemText("item 1"),
                ItemText("item 2"),
              ],
            ));
      },
      expect: [
        TaskFormState(
          TaskPrimitive.empty().copyWith(
            description: "",
            checklists: [
              ChecklistPrimitive(
                title: "Checklist 1 (edited)",
                items: [
                  ItemText("item 1"),
                  ItemText("item 2"),
                ],
              ),
              ChecklistPrimitive(
                title: "Checklist 2",
                items: [ItemText("item 1")],
              ),
            ],
          ),
          false,
          false,
        ),
      ],
    );

    blocTest(
      "save emit state",
      build: () => TaskFormBloc(Maybe.nothing()),
      act: (TaskFormBloc cubit) => cubit.saveTask(),
      expect: [
        // TODO: Test this after the implementation change!
        TaskFormState(
          TaskPrimitive.empty(),
          true,
          false,
        ),
        TaskFormState(
          TaskPrimitive.empty(),
          false,
          false,
        ),
      ],
    );
  });
}
