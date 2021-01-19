import 'package:aspdm_project/application/bloc/task_form_bloc.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskFormInputWidget extends StatelessWidget {
  TaskFormInputWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<TaskFormBloc, TaskFormState>(
              buildWhen: (_, c) => c.isInitial,
              builder: (context, state) => TextFormField(
                initialValue: state.taskPrimitive.title.value.getOrNull(),
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
                validator: (_) => context
                    .read<TaskFormBloc>()
                    .state
                    .taskPrimitive
                    .title
                    .value
                    .fold(
                      // TODO(#25): Add maybeMap to ValueFailure like reso did.
                      (left) => "Invalid",
                      (_) => null,
                    ),
              ),
            ),
            BlocBuilder<TaskFormBloc, TaskFormState>(
              buildWhen: (_, c) => c.isInitial,
              builder: (context, state) => TextFormField(
                initialValue: state.taskPrimitive.description.value.getOrNull(),
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
                validator: (_) => context
                    .read<TaskFormBloc>()
                    .state
                    .taskPrimitive
                    .description
                    .value
                    .fold((left) => "invalid", (_) => null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
