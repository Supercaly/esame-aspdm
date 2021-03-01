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
import 'package:mocktail/mocktail.dart';
import '../../../../widget_tester_extension.dart';

class MockTaskFormBloc extends MockCubit<TaskFormState>
    implements TaskFormBloc {}

void main() {
  group("TaskFormInputWidget tests", () {
    testWidgets("create with null initial data", (tester) async {
      final bloc = MockTaskFormBloc();
      when(bloc)
          .calls(#state)
          .thenReturn(TaskFormState.initial(Maybe.nothing()));
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
      bloc.close();
    });

    testWidgets("create with some initial data", (tester) async {
      final task = Task.test(
        id: UniqueId.empty(),
        title: TaskTitle("Mock Title"),
        description: Maybe.just(TaskDescription("Mock Description")),
      );
      final bloc = MockTaskFormBloc();
      when(bloc)
          .calls(#state)
          .thenReturn(TaskFormState.initial(Maybe.just(task)));

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
      expect(
        find.text(task.description.getOrNull()?.value?.getOrNull()),
        findsOneWidget,
      );
      bloc.close();
    });

    testWidgets("edit fields changes calls bloc", (tester) async {
      final bloc = MockTaskFormBloc();
      when(bloc)
          .calls(#state)
          .thenReturn(TaskFormState.initial(Maybe.nothing()));
      when(bloc)
          .calls(#titleChanged)
          .withArgs(positional: [any]).thenReturn(null);
      when(bloc)
          .calls(#descriptionChanged)
          .withArgs(positional: [any]).thenReturn(null);


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
      verify(bloc).called(#titleChanged).withArgs(positional: [any]).times(1);
      verify(bloc)
          .called(#descriptionChanged)
          .withArgs(positional: [any]).never();

      await tester.enterText(
          find.byType(TextFormField).at(1), "Mock Description");
      expect(find.text("Mock Description"), findsOneWidget);
      verify(bloc)
          .called(#descriptionChanged)
          .withArgs(positional: [any]).times(1);
      bloc.close();
    });

    testWidgets("validate fields ", (tester) async {
      final formKey = GlobalKey<FormState>();
      final bloc = MockTaskFormBloc();
      when(bloc)
          .calls(#state)
          .thenReturn(TaskFormState.initial(Maybe.nothing()));
      when(bloc)
          .calls(#titleChanged)
          .withArgs(positional: [any]).thenReturn(null);

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

      when(bloc).calls(#state).thenReturn(
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
      bloc.close();
    });
  });
}
