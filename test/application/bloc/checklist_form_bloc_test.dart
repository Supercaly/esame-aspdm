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
        ChecklistFormState(ChecklistTitle("Checklist"), [], false),
      ),
    );

    blocTest(
      "emits nothing when created with initial value",
      build: () => ChecklistFormBloc(
        initialValue: ChecklistPrimitive(
          title: ChecklistTitle("Mock Title"),
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
          ChecklistTitle("Mock Title"),
          [
            ItemText("Mock Item 1"),
            ItemText("Mock Item 2"),
          ],
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
          ChecklistTitle("Mock Title"),
          [],
          false,
        ),
      ],
    );

    blocTest(
      "emits on item added",
      build: () => ChecklistFormBloc(
        initialValue: ChecklistPrimitive(
          title: ChecklistTitle("Mock Title"),
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
          ChecklistTitle("Mock Title"),
          [
            ItemText("Mock Item 1"),
            ItemText("Mock Item 2"),
          ],
          false,
        ),
      ],
    );

    blocTest(
      "emits on item removed",
      build: () => ChecklistFormBloc(
        initialValue: ChecklistPrimitive(
          title: ChecklistTitle("Mock Title"),
          items: [
            ItemText("Mock Item 1"),
            ItemText("Mock Item 2"),
            ItemText("Mock Item 3"),
          ],
        ),
      ),
      act: (ChecklistFormBloc cubit) {
        cubit.removeItem(1);
      },
      expect: [
        ChecklistFormState(
          ChecklistTitle("Mock Title"),
          [
            ItemText("Mock Item 1"),
            ItemText("Mock Item 3"),
          ],
          false,
        ),
      ],
    );

    blocTest(
      "emits on item removed",
      build: () => ChecklistFormBloc(
        initialValue: ChecklistPrimitive(
          title: ChecklistTitle("Mock Title"),
          items: [
            ItemText("Mock Item 1"),
            ItemText("Mock Item 2"),
            ItemText("Mock Item 3"),
          ],
        ),
      ),
      act: (ChecklistFormBloc cubit) {
        cubit.editItem(1, ItemText("Mock Item 2 (Edited)"));
      },
      expect: [
        ChecklistFormState(
          ChecklistTitle("Mock Title"),
          [
            ItemText("Mock Item 1"),
            ItemText("Mock Item 2 (Edited)"),
            ItemText("Mock Item 3"),
          ],
          false,
        ),
      ],
    );

    blocTest(
      "emits on save",
      build: () => ChecklistFormBloc(
        initialValue: ChecklistPrimitive(
          title: ChecklistTitle("Mock Title"),
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
          ChecklistTitle("Mock Title"),
          [
            ItemText("Mock Item 1"),
            ItemText("Mock Item 2"),
            ItemText("Mock Item 3"),
          ],
          true,
        ),
      ],
    );
  });
}
