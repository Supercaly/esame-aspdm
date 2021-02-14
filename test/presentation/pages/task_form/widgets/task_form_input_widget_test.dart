import 'package:tasky/application/bloc/task_form_bloc.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/presentation/pages/task_form/widgets/task_form_input_widget.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../widget_tester_extension.dart';

class MockTaskFormBloc extends MockBloc<TaskFormState> implements TaskFormBloc {
}

void main() {
  group("TaskFormInputWidget tests", () {
    testWidgets("create with null initial data", (tester) async {
      final bloc = MockTaskFormBloc();
      when(bloc.state).thenReturn(TaskFormState.initial(Maybe.nothing()));
      await tester.pumpLocalizedWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<TaskFormBloc>.value(
              value: bloc,
              child: TaskFormInputWidget(),
            ),
          ),
        ),
      );

      expect(find.text("Title..."), findsOneWidget);
      expect(find.text("Description"), findsOneWidget);
    });

    testWidgets("create with some initial data", (tester) async {
      final task = Task(
        UniqueId.empty(),
        TaskTitle("Mock Title"),
        TaskDescription("Mock Description"),
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
      );
      final bloc = MockTaskFormBloc();
      when(bloc.state).thenReturn(TaskFormState.initial(Maybe.just(task)));

      await tester.pumpLocalizedWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<TaskFormBloc>.value(
              value: bloc,
              child: TaskFormInputWidget(),
            ),
          ),
        ),
      );

      expect(find.text(task.title.value.getOrNull()), findsOneWidget);
      expect(find.text(task.description.value.getOrNull()), findsOneWidget);
    });

    testWidgets("edit fields changes calls bloc", (tester) async {
      final bloc = MockTaskFormBloc();
      when(bloc.state).thenReturn(TaskFormState.initial(Maybe.nothing()));
      await tester.pumpLocalizedWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<TaskFormBloc>.value(
              value: bloc,
              child: TaskFormInputWidget(),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, "Mock Title");
      expect(find.text("Mock Title"), findsOneWidget);
      expect(find.text("Description"), findsOneWidget);
      verify(bloc.titleChanged(any)).called(1);
      verifyNever(bloc.descriptionChanged(any));

      await tester.enterText(
          find.byType(TextFormField).at(1), "Mock Description");
      expect(find.text("Mock Description"), findsOneWidget);
      verify(bloc.descriptionChanged(any)).called(1);
    });

    testWidgets("validate fields ", (tester) async {
      final formKey = GlobalKey<FormState>();
      final bloc = MockTaskFormBloc();
      when(bloc.state).thenReturn(TaskFormState.initial(Maybe.nothing()));
      await tester.pumpLocalizedWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: BlocProvider<TaskFormBloc>.value(
                value: bloc,
                child: TaskFormInputWidget(),
              ),
            ),
          ),
        ),
      );

      expect(formKey.currentState.validate(), isFalse);
      await tester.pumpAndSettle();
      expect(find.text("Title can't be empty!"), findsOneWidget);

      when(bloc.state).thenReturn(
        bloc.state.copyWith(
          taskPrimitive: bloc.state.taskPrimitive.copyWith(
            title: "Mock Title",
          ),
        ),
      );
      await tester.enterText(find.byType(TextFormField).first, "Mock Title");
      expect(find.text("Mock Title"), findsOneWidget);
      expect(formKey.currentState.validate(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text("Title can't be empty!"), findsNothing);
    });
  });
}
