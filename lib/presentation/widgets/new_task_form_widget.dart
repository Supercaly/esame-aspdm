import 'package:aspdm_project/application/bloc/task_form_bloc.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewTaskFormWidget extends StatefulWidget {
  NewTaskFormWidget({Key key}) : super(key: key);

  @override
  _NewTaskFormWidgetState createState() => _NewTaskFormWidgetState();
}

class _NewTaskFormWidgetState extends State<NewTaskFormWidget> {
  TextEditingController _titleController;
  TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TODO: Builder is maybe irrelevant
            BlocBuilder<TaskFormBloc, TaskFormState>(
              buildWhen: (p, c) =>
                  p.taskPrimitive.title != c.taskPrimitive.title,
              builder: (context, state) => TextFormField(
                controller: _titleController,
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
                validator: (value) => context
                    .read<TaskFormBloc>()
                    .state
                    .taskPrimitive
                    .title
                    .value
                    .fold(
                      // TODO: Add maybeMap to ValueFailure like reso did.
                      (left) => "Invalid",
                      (_) => null,
                    ),
              ),
            ),
            BlocBuilder<TaskFormBloc, TaskFormState>(
              builder: (context, state) => TextFormField(
                controller: _descriptionController,
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
                validator: (value) => context
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
