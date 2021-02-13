// @dart=2.9
import 'package:tasky/application/bloc/task_form_bloc.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

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
                  hintText: 'title_hint'.tr(),
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
                        empty: (_) => 'title_cant_be_empty_msg'.tr(),
                        tooLong: (_) => 'title_cant_be_longer_msg'
                            .tr(args: [TaskTitle.maxLength.toString()]),
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
                  hintText: 'description_hint'.tr(),
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
                        tooLong: (_) => 'description_cant_be_longer'
                            .tr(args: [TaskDescription.maxLength.toString()]),
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
