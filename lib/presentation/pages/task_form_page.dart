import 'package:aspdm_project/application/bloc/task_form_bloc.dart';
import 'package:aspdm_project/core/ilist.dart';
import 'package:aspdm_project/core/maybe.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/repositories/task_form_repository.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/presentation/dialogs/checklist_form_dialog.dart';
import 'package:aspdm_project/presentation/dialogs/label_picker_dialog.dart';
import 'package:aspdm_project/presentation/dialogs/members_picker_dialog.dart';
import 'package:aspdm_project/presentation/misc/checklist_primitive.dart';
import 'package:aspdm_project/presentation/pages/checklist_form_page.dart';
import 'package:aspdm_project/presentation/sheets/label_picker_sheet.dart';
import 'package:aspdm_project/presentation/sheets/members_picker_sheet.dart';
import 'package:aspdm_project/presentation/widgets/checklist_widget.dart';
import 'package:aspdm_project/presentation/widgets/label_widget.dart';
import 'package:aspdm_project/presentation/widgets/responsive.dart';
import 'package:aspdm_project/presentation/widgets/task_form_input_widget.dart';
import 'package:aspdm_project/presentation/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:aspdm_project/application/states/auth_state.dart';

import '../theme.dart';

class TaskFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Maybe<Task> task = locator<NavigationService>().arguments(context);

    return BlocProvider(
      create: (context) => TaskFormBloc(
        oldTask: task,
        repository: locator<TaskFormRepository>(),
      ),
      child: BlocListener<TaskFormBloc, TaskFormState>(
        listenWhen: (_, c) => c.saved,
        listener: (context, state) =>
            locator<NavigationService>().pop(result: true),
        child: TaskFormPageScaffold(),
      ),
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
        title: BlocBuilder<TaskFormBloc, TaskFormState>(
          buildWhen: (p, c) => p.mode != c.mode,
          builder: (context, state) => Text(
            (state.mode == TaskFormMode.creating) ? "New Task" : "Edit Task",
          ),
        ),
        centerTitle: true,
        // TODO: This IconButton will be unused if this page is opened as a fullscreen dialog
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => locator<NavigationService>().pop(),
        ),
        actions: [
          BlocBuilder<TaskFormBloc, TaskFormState>(
            buildWhen: (p, c) => p.mode != c.mode,
            builder: (context, state) => TextButton(
                style: TextButton.styleFrom(primary: Colors.white),
                child: Text((state.mode == TaskFormMode.creating)
                    ? "CREATE"
                    : "UPDATE"),
                onPressed: () async {
                  if (_formKey.currentState.validate())
                    await context.read<TaskFormBloc>().saveTask(context
                        .read<AuthState>()
                        .currentUser
                        .fold(() => null, (u) => u.id));
                }),
          ),
        ],
      ),
      body: BlocConsumer<TaskFormBloc, TaskFormState>(
        listenWhen: (p, c) => !p.hasError && c.hasError,
        listener: (context, state) =>
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error saving task!"),
            action: SnackBarAction(
              label: "RETRY",
              onPressed: () async {
                if (_formKey.currentState.validate())
                  await context.read<TaskFormBloc>().saveTask(context
                      .read<AuthState>()
                      .currentUser
                      .fold(() => null, (u) => u.id));
              },
            ),
          ),
        ),
        buildWhen: (p, c) => p.isSaving != c.isSaving,
        builder: (context, state) => LoadingOverlay(
          color: Colors.black45,
          isLoading: state.isSaving,
          child: Center(
            child: Theme(
              data: Responsive.isLarge(context)
                  ? Theme.of(context).brightness == Brightness.light
                      ? lightThemeDesktop
                      : darkThemeDesktop
                  : Theme.of(context),
              child: Container(
                width: Responsive.isLarge(context) ? 500 : double.maxFinite,
                padding: Responsive.isLarge(context)
                    ? const EdgeInsets.only(top: 24.0)
                    : null,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TaskFormInputWidget(),
                      Card(
                        child: Column(
                          children: [
                            BlocBuilder<TaskFormBloc, TaskFormState>(
                              buildWhen: (p, c) =>
                                  p.taskPrimitive.expireDate !=
                                  c.taskPrimitive.expireDate,
                              builder: (context, state) => ListTile(
                                leading: Icon(FeatherIcons.calendar),
                                title: (state.taskPrimitive.expireDate
                                            .getOrNull() !=
                                        null)
                                    ? Text(DateFormat("dd MMM y HH:mm").format(
                                        state.taskPrimitive.expireDate
                                            .getOrNull()))
                                    : Text("Expiration Date..."),
                                trailing: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () => context
                                      .read<TaskFormBloc>()
                                      .dateChanged(Maybe.nothing()),
                                ),
                                onTap: () async {
                                  // TODO(#39): Replace date picker with date-time picker
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: state.taskPrimitive.expireDate
                                            .getOrNull() ??
                                        DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2030),
                                  );
                                  if (pickedDate != null &&
                                      pickedDate !=
                                          state.taskPrimitive.expireDate
                                              .getOrNull())
                                    context
                                        .read<TaskFormBloc>()
                                        .dateChanged(Maybe.just(pickedDate));
                                },
                              ),
                            ),
                            BlocBuilder<TaskFormBloc, TaskFormState>(
                              buildWhen: (p, c) =>
                                  p.taskPrimitive.members !=
                                  c.taskPrimitive.members,
                              builder: (context, state) => ListTile(
                                leading: Icon(FeatherIcons.users),
                                title: (state.taskPrimitive.members != null &&
                                        state.taskPrimitive.members.isNotEmpty)
                                    ? Wrap(
                                        spacing: 8.0,
                                        runSpacing: 4.0,
                                        children: state.taskPrimitive.members
                                            .map((e) => UserAvatar(
                                                  user: e,
                                                  size: 32.0,
                                                ))
                                            .asList())
                                    : Text("Members..."),
                                onTap: () async {
                                  IList<User> selectedMembers;
                                  if (Responsive.isSmall(context))
                                    selectedMembers =
                                        await showMembersPickerSheet(
                                      context,
                                      state.taskPrimitive.members,
                                    );
                                  else
                                    selectedMembers =
                                        await showMembersPickerDialog(
                                      context,
                                      state.taskPrimitive.members,
                                    );
                                  if (selectedMembers != null)
                                    context
                                        .read<TaskFormBloc>()
                                        .membersChanged(selectedMembers);
                                },
                              ),
                            ),
                            BlocBuilder<TaskFormBloc, TaskFormState>(
                              builder: (context, state) => ListTile(
                                leading: Icon(FeatherIcons.tag),
                                title: (state.taskPrimitive.labels != null &&
                                        state.taskPrimitive.labels.isNotEmpty)
                                    ? Wrap(
                                        spacing: 8.0,
                                        runSpacing: 4.0,
                                        children: state.taskPrimitive.labels
                                            .map((e) => LabelWidget(label: e))
                                            .asList(),
                                      )
                                    : Text("Labels..."),
                                onTap: () async {
                                  IList<Label> selectedLabels;
                                  if (Responsive.isSmall(context))
                                    selectedLabels = await showLabelPickerSheet(
                                      context,
                                      state.taskPrimitive.labels,
                                    );
                                  else
                                    selectedLabels =
                                        await showLabelPickerDialog(
                                      context,
                                      state.taskPrimitive.labels,
                                    );
                                  if (selectedLabels != null)
                                    context
                                        .read<TaskFormBloc>()
                                        .labelsChanged(selectedLabels);
                                },
                              ),
                            ),
                            ListTile(
                              leading: Icon(FeatherIcons.checkCircle),
                              title: Text("Add checklist..."),
                              onTap: () async {
                                ChecklistPrimitive newChecklist;
                                if (Responsive.isSmall(context))
                                  newChecklist = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChecklistFormPage(),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                else
                                  newChecklist = await showChecklistFormDialog(
                                      context, null);
                                if (newChecklist != null)
                                  context
                                      .read<TaskFormBloc>()
                                      .addChecklist(newChecklist);
                              },
                            )
                          ],
                        ),
                      ),
                      BlocBuilder<TaskFormBloc, TaskFormState>(
                        buildWhen: (p, s) =>
                            p.taskPrimitive.checklists !=
                            s.taskPrimitive.checklists,
                        builder: (context, state) => Column(
                          children: state.taskPrimitive.checklists
                              .map((e) => EditChecklist(
                                    primitive: e,
                                    onTap: () async {
                                      ChecklistPrimitive editedChecklist;
                                      if (Responsive.isSmall(context))
                                        editedChecklist = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ChecklistFormPage(
                                              primitive: e,
                                            ),
                                            fullscreenDialog: true,
                                          ),
                                        );
                                      else
                                        editedChecklist =
                                            await showChecklistFormDialog(
                                                context, e);
                                      if (editedChecklist != null)
                                        context
                                            .read<TaskFormBloc>()
                                            .editChecklist(e, editedChecklist);
                                    },
                                    onRemove: () => context
                                        .read<TaskFormBloc>()
                                        .removeChecklist(e),
                                  ))
                              .asList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
