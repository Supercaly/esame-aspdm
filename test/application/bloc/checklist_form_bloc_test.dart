import 'package:aspdm_project/application/bloc/checklist_form_bloc.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/presentation/misc/checklist_primitive.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("ChecklistFormBloc Tests", () {
    blocTest(
      "emits nothing when created with no initial value",
      build: () => ChecklistFormBloc(),
      expect: [],
      verify: (ChecklistFormBloc cubit) => expect(
        cubit.state,
        ChecklistFormState(
          ChecklistPrimitive(title: "Checklist", items: []),
          false,
        ),
      ),
    );

    blocTest(
      "emits nothing when created with initial value",
      build: () => ChecklistFormBloc(
        initialValue: ChecklistPrimitive(
          title: "Mock Title",
          items: [
            ItemText("Mock Item 1"),
            ItemText("Mock Item 2"),
          ],
        ),
      ),
      expect: [],
      verify: (ChecklistFormBloc cubit) => expect(
        cubit.state,
        ChecklistFormState(
          ChecklistPrimitive(
            title: "Mock Title",
            items: [
              ItemText("Mock Item 1"),
              ItemText("Mock Item 2"),
            ],
          ),
          false,
        ),
      ),
    );

    blocTest(
      "emits on title changed",
      build: () => ChecklistFormBloc(),
      act: (ChecklistFormBloc cubit) => cubit.titleChanged("Mock Title"),
      expect: [
        ChecklistFormState(
          ChecklistPrimitive(title: "Mock Title", items: []),
          false,
        ),
      ],
    );

    blocTest(
      "emits on item added",
      build: () => ChecklistFormBloc(
        initialValue: ChecklistPrimitive(
          title: "Mock Title",
          items: [
            ItemText("Mock Item 1"),
          ],
        ),
      ),
      act: (ChecklistFormBloc cubit) {
        cubit.addItem(ItemText("Mock Item 2"));
      },
      expect: [
        ChecklistFormState(
          ChecklistPrimitive(
            title: "Mock Title",
            items: [
              ItemText("Mock Item 1"),
              ItemText("Mock Item 2"),
            ],
          ),
          false,
        ),
      ],
    );

    blocTest(
      "emits on item removed",
      build: () => ChecklistFormBloc(
        initialValue: ChecklistPrimitive(
          title: "Mock Title",
          items: [
            ItemText("Mock Item 1"),
            ItemText("Mock Item 2"),
            ItemText("Mock Item 3"),
          ],
        ),
      ),
      act: (ChecklistFormBloc cubit) {
        cubit.removeItem(ItemText("Mock Item 2"));
      },
      expect: [
        ChecklistFormState(
          ChecklistPrimitive(
            title: "Mock Title",
            items: [
              ItemText("Mock Item 1"),
              ItemText("Mock Item 3"),
            ],
          ),
          false,
        ),
      ],
    );

    blocTest(
      "emits on item edited",
      build: () => ChecklistFormBloc(
        initialValue: ChecklistPrimitive(
          title: "Mock Title",
          items: [
            ItemText("Mock Item 1"),
            ItemText("Mock Item 2"),
            ItemText("Mock Item 3"),
          ],
        ),
      ),
      act: (ChecklistFormBloc cubit) {
        cubit.editItem(
          ItemText("Mock Item 2"),
          ItemText("Mock Item 2 (Edited)"),
        );
      },
      expect: [
        ChecklistFormState(
          ChecklistPrimitive(
            title: "Mock Title",
            items: [
              ItemText("Mock Item 1"),
              ItemText("Mock Item 2 (Edited)"),
              ItemText("Mock Item 3"),
            ],
          ),
          false,
        ),
      ],
    );

    blocTest(
      "emits on save",
      build: () => ChecklistFormBloc(
        initialValue: ChecklistPrimitive(
          title: "Mock Title",
          items: [
            ItemText("Mock Item 1"),
            ItemText("Mock Item 2"),
            ItemText("Mock Item 3"),
          ],
        ),
      ),
      act: (ChecklistFormBloc cubit) {
        cubit.save();
      },
      expect: [
        ChecklistFormState(
          ChecklistPrimitive(
            title: "Mock Title",
            items: [
              ItemText("Mock Item 1"),
              ItemText("Mock Item 2"),
              ItemText("Mock Item 3"),
            ],
          ),
          true,
        ),
      ],
    );
  });
}
