import 'package:aspdm_project/application/bloc/task_form_bloc.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget that displays an input form where the user
/// can insert a title and a description.
/// This Widget is used only inside [TaskFormPage].
class TaskFormInputWidget extends StatelessWidget {
  const TaskFormInputWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<TaskFormBloc, TaskFormState>(
              buildWhen: (_, __) => false,
              builder: (context, state) => TextFormField(
                initialValue: state.taskPrimitive.title,
                style: Theme.of(context).textTheme.headline6,
                maxLength: TaskTitle.maxLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                decoration: InputDecoration(
                  hintText: "Title...",
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  counterText: "",
                ),
                onChanged: (value) =>
                    context.read<TaskFormBloc>().titleChanged(value),
                validator: (value) => TaskTitle(value).value.fold(
                      (left) => left.maybeMap(
                        empty: (_) => "Title can't be empty!",
                        tooLong: (_) =>
                            "Title can't be longer than ${TaskTitle.maxLength}!",
                        orElse: () => null,
                      ),
                      (_) => null,
                    ),
              ),
            ),
            BlocBuilder<TaskFormBloc, TaskFormState>(
              buildWhen: (_, __) => false,
              builder: (context, state) => TextFormField(
                initialValue: state.taskPrimitive.description,
                style: Theme.of(context).textTheme.bodyText2,
                maxLength: TaskDescription.maxLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                maxLines: null,
                minLines: 3,
                decoration: InputDecoration(
                  hintText: "Description",
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                onChanged: (value) =>
                    context.read<TaskFormBloc>().descriptionChanged(value),
                validator: (value) => TaskDescription(value).value.fold(
                      (left) => left.maybeMap(
                        tooLong: (_) =>
                            "Description can't be longer than ${TaskDescription.maxLength}!",
                        orElse: () => null,
                      ),
                      (_) => null,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
