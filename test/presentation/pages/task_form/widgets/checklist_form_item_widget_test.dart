import 'package:easy_localization/easy_localization.dart';
import 'package:tasky/application/bloc/checklist_form_bloc.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/presentation/pages/task_form/misc/checklist_primitive.dart';
import 'package:tasky/presentation/pages/task_form/widgets/checklist_form_item_widget.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../widget_tester_extension.dart';

class MockChecklistFormBloc extends MockCubit<ChecklistFormState>
    implements ChecklistFormBloc {}

void main() async {
  EasyLocalization.logger.enableBuildModes = [];
  await EasyLocalization.ensureInitialized();

  group("ChecklistFormTitleWidget test", () {
    ChecklistFormBloc bloc;

    setUpAll(() {
      bloc = MockChecklistFormBloc();
    });

    testWidgets("changing title calls bloc", (tester) async {
      final form = GlobalKey<FormState>();
      when(bloc).calls(#titleChanged).thenReturn();
      when(bloc)
          .calls(#state)
          .thenReturn(ChecklistFormState.initial(ChecklistPrimitive.empty()));

      await tester.pumpLocalizedWidget(
        Form(
          key: form,
          child: BlocProvider<ChecklistFormBloc>.value(
            value: bloc,
            child: ChecklistFormTitleWidget(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), "Mock title");
      await tester.pumpAndSettle();
      expect(find.text("Mock title"), findsOneWidget);
      verify(bloc).called(#titleChanged).once();
    });

    testWidgets("when editing displays the existing title", (tester) async {
      final form = GlobalKey<FormState>();
      when(bloc).calls(#state).thenReturn(
            ChecklistFormState.initial(
              ChecklistPrimitive(
                title: "Mock title",
                items: null,
              ),
            ),
          );

      await tester.pumpLocalizedWidget(
        Form(
          key: form,
          child: BlocProvider<ChecklistFormBloc>.value(
            value: bloc,
            child: ChecklistFormTitleWidget(),
          ),
        ),
      );

      expect(find.text("Mock title"), findsOneWidget);
    });

    testWidgets("validate works correctly", (tester) async {
      final form = GlobalKey<FormState>();
      when(bloc)
          .calls(#state)
          .thenReturn(ChecklistFormState.initial(ChecklistPrimitive.empty()));

      await tester.pumpLocalizedWidget(
        Form(
          key: form,
          child: BlocProvider<ChecklistFormBloc>.value(
            value: bloc,
            child: ChecklistFormTitleWidget(),
          ),
        ),
      );

      // Validate empty text returns error
      form.currentState.validate();
      await tester.pumpAndSettle();
      expect(find.text("Title can't be empty!"), findsOneWidget);

      // Validate non-empty text returns error
      await tester.enterText(find.byType(TextFormField), "Mock title");
      await tester.pumpAndSettle();
      form.currentState.validate();
      await tester.pumpAndSettle();
      expect(find.text("Title can't be empty!"), findsNothing);
    });
  });

  group("ChecklistFormNewItemWidget test", () {
    ChecklistFormBloc bloc;

    setUpAll(() {
      bloc = MockChecklistFormBloc();
    });

    testWidgets("displays hind when started", (tester) async {
      final form = GlobalKey<FormState>();
      whenListen(
        bloc,
        Stream<ChecklistFormState>.empty(),
        initialState: ChecklistFormState.initial(ChecklistPrimitive.empty()),
      );

      await tester.pumpLocalizedWidget(
        Form(
          key: form,
          child: BlocProvider<ChecklistFormBloc>.value(
            value: bloc,
            child: ChecklistFormNewItemWidget(),
          ),
        ),
      );

      expect(find.text("Add item..."), findsOneWidget);
    });

    testWidgets("calls bloc on insertion completed", (tester) async {
      final form = GlobalKey<FormState>();
      when(bloc)
          .calls(#state)
          .thenReturn(ChecklistFormState.initial(ChecklistPrimitive.empty()));
      when(bloc).calls(#addItem).thenReturn();

      await tester.pumpLocalizedWidget(
        Form(
          key: form,
          child: BlocProvider<ChecklistFormBloc>.value(
            value: bloc,
            child: ChecklistFormNewItemWidget(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), "Mock item");
      expect(find.text("Mock item"), findsOneWidget);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      verify(bloc)
          .called(#addItem)
          .withArgs(positional: [ItemText("Mock item")]).once();
      expect(find.text("Mock item"), findsNothing);
    });
  });

  group("ChecklistFormItem test", () {
    ChecklistFormBloc bloc;

    setUpAll(() {
      bloc = MockChecklistFormBloc();
    });

    testWidgets("display item correctly", (tester) async {
      final form = GlobalKey<FormState>();
      await tester.pumpLocalizedWidget(
        Form(
          key: form,
          child: BlocProvider<ChecklistFormBloc>.value(
            value: bloc,
            child: ChecklistFormItem(
              item: ItemText("Mock item"),
            ),
          ),
        ),
      );
      expect(find.text("Mock item"), findsOneWidget);
    });

    testWidgets("editing item calls bloc", (tester) async {
      final form = GlobalKey<FormState>();
      when(bloc).calls(#editItem).thenReturn();

      await tester.pumpLocalizedWidget(
        Form(
          key: form,
          child: BlocProvider<ChecklistFormBloc>.value(
            value: bloc,
            child: ChecklistFormItem(
              item: ItemText("Mock item"),
            ),
          ),
        ),
      );

      expect(find.text("Mock item"), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), "Mock item(edited)");
      await tester.pumpAndSettle();
      expect(find.text("Mock item(edited)"), findsOneWidget);
      verify(bloc).called(#editItem).once();
    });

    testWidgets("validate works correctly", (tester) async {
      final form = GlobalKey<FormState>();
      when(bloc)
          .calls(#state)
          .thenReturn(ChecklistFormState.initial(ChecklistPrimitive.empty()));
      when(bloc).calls(#editItem).thenReturn();

      await tester.pumpLocalizedWidget(
        Form(
          key: form,
          child: BlocProvider<ChecklistFormBloc>.value(
            value: bloc,
            child: ChecklistFormItem(item: ItemText("Mock item")),
          ),
        ),
      );

      // Validate non-empty text has no error
      form.currentState.validate();
      await tester.pumpAndSettle();
      expect(find.text("Item can't be empty!"), findsNothing);

      // Validate empty text returns error
      await tester.enterText(find.byType(TextFormField), "");
      await tester.pumpAndSettle();
      form.currentState.validate();
      await tester.pumpAndSettle();
      expect(find.text("Item can't be empty!"), findsOneWidget);
    });
  });
}
