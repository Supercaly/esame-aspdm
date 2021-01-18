import 'package:aspdm_project/application/bloc/task_form_bloc.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/domain/values/user_values.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/presentation/widgets/checklist_widget.dart';
import 'package:aspdm_project/presentation/widgets/label_widget.dart';
import 'package:aspdm_project/presentation/widgets/new_task_form_widget.dart';
import 'package:aspdm_project/presentation/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';

class TaskFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // TODO: Pass the task obtained from NavigationService.arguments
      create: (context) => TaskFormBloc(null),
      child: TaskFormPageScaffold(),
    );
  }
}

class TaskFormPageScaffold extends StatefulWidget {
  @override
  _TaskFormPageScaffoldState createState() => _TaskFormPageScaffoldState();
}

class _TaskFormPageScaffoldState extends State<TaskFormPageScaffold> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO: Change title from new to edit if it's editing the task
        title: Text("New Task"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => locator<NavigationService>().pop(),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                if (_formKey.currentState.validate())
                  await context.read<TaskFormBloc>().saveTask();
              }),
        ],
      ),
      body: BlocBuilder<TaskFormBloc, TaskFormState>(
        // TODO: Build only when save changes
        buildWhen: (p, c) => p.isSaving != c.isSaving,
        builder: (context, state) => LoadingOverlay(
          color: Colors.black45,
          isLoading: state.isSaving,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                NewTaskFormWidget(),
                Card(
                  child: Column(
                    children: [
                      BlocBuilder<TaskFormBloc, TaskFormState>(
                        buildWhen: (p, c) =>
                            p.task.expireDate != c.task.expireDate,
                        builder: (context, state) => ListTile(
                          // TODO: Add trailing icon button to delete the selected date
                          leading: Icon(FeatherIcons.calendar),
                          title: (state.task.expireDate != null)
                              ? Text(DateFormat("dd MMM y HH:mm")
                                  .format(state.task.expireDate))
                              : Text("Expiration Date..."),
                          onTap: () async {
                            // TODO: Replace with date-time picker
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  state.task.expireDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2030),
                            );
                            if (pickedDate != null &&
                                pickedDate != state.task.expireDate)
                              context
                                  .read<TaskFormBloc>()
                                  .dateChanged(pickedDate);
                          },
                        ),
                      ),
                      BlocBuilder<TaskFormBloc, TaskFormState>(
                        buildWhen: (p, c) => p.task.members != c.task.members,
                        builder: (context, state) => ListTile(
                          leading: Icon(FeatherIcons.users),
                          title: (state.task.members != null)
                              ? Wrap(
                                  spacing: 8.0,
                                  runSpacing: 4.0,
                                  children: state.task.members
                                      .map((e) => UserAvatar(
                                            user: e,
                                            size: 32.0,
                                          ))
                                      .toList())
                              : Text("Members..."),
                          onTap: () {
                            context.read<TaskFormBloc>().membersChanged([
                              User(UniqueId("user1"), UserName("Jonny"),
                                  EmailAddress("aa@bb.com"), Colors.red),
                              User(UniqueId("user2"), UserName("Lucas"),
                                  EmailAddress("bb@bb.com"), Colors.green),
                              User(UniqueId("user3"), UserName("Michael"),
                                  EmailAddress("cc@bb.com"), Colors.blue),
                            ]);
                          },
                        ),
                      ),
                      BlocBuilder<TaskFormBloc, TaskFormState>(
                        builder: (context, state) => ListTile(
                          leading: Icon(FeatherIcons.tag),
                          title: (state.task.labels != null)
                              ? Wrap(
                                  spacing: 8.0,
                                  runSpacing: 4.0,
                                  children: state.task.labels
                                      .map((e) => LabelWidget(label: e))
                                      .toList(),
                                )
                              : Text("Labels..."),
                          onTap: () {
                            context.read<TaskFormBloc>().labelsChanged([
                              Label(UniqueId("label 1"), Colors.yellow,
                                  "label 1"),
                              Label(
                                  UniqueId("label 2"), Colors.green, "label 1"),
                              Label(
                                  UniqueId("label 3"), Colors.blue, "label 1"),
                            ]);
                          },
                        ),
                      ),
                      ListTile(
                        leading: Icon(FeatherIcons.checkCircle),
                        title: Text("Add checklist..."),
                        onTap: () {
                          context.read<TaskFormBloc>().addChecklist();
                        },
                      )
                    ],
                  ),
                ),
                BlocBuilder<TaskFormBloc, TaskFormState>(
                  buildWhen: (p, s) => p.task.checklists != s.task.checklists,
                  builder: (context, state) => Column(
                    children: state.task.checklists
                        .map((e) => EditChecklist(checklist: e))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
