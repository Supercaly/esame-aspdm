import 'package:tasky/application/bloc/task_form_bloc.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/entities/label.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/repositories/task_form_repository.dart';
import 'package:tasky/locator.dart';
import 'package:tasky/presentation/pages/task_form/widgets/checklist_form_dialog.dart';
import 'package:tasky/presentation/pages/task_form/widgets/label_picker_dialog.dart';
import 'package:tasky/presentation/pages/task_form/widgets/members_picker_dialog.dart';
import 'package:tasky/presentation/pages/task_form/misc/checklist_primitive.dart';
import 'package:tasky/presentation/pages/task_form/checklist_form_page.dart';
import 'package:tasky/presentation/pages/task_form/widgets/label_picker_sheet.dart';
import 'package:tasky/presentation/pages/task_form/widgets/members_picker_sheet.dart';
import 'package:tasky/presentation/widgets/checklist_widget.dart';
import 'package:tasky/presentation/widgets/label_widget.dart';
import 'package:tasky/presentation/widgets/responsive.dart';
import 'package:tasky/presentation/pages/task_form/widgets/task_form_input_widget.dart';
import 'package:tasky/presentation/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:tasky/services/navigation_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:tasky/application/states/auth_state.dart';
import 'package:tasky/presentation/pages/task_form/misc/date_time_extension.dart';
import '../../theme.dart';
import 'package:easy_localization/easy_localization.dart';

class TaskFormPage extends StatelessWidget {
  final Maybe<Task> task;

  const TaskFormPage({
    Key key,
    @required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            (state.mode == TaskFormMode.creating)
                ? 'new_task_title'
                : 'edit_task_title',
          ).tr(),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<TaskFormBloc, TaskFormState>(
            buildWhen: (p, c) => p.mode != c.mode,
            builder: (context, state) => TextButton(
                style: TextButton.styleFrom(primary: Colors.white),
                child: Text(
                  (state.mode == TaskFormMode.creating)
                      ? 'create_btn'
                      : 'update_btn',
                ).tr(),
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
            content: Text('error_saving_task_msg').tr(),
            action: SnackBarAction(
              label: 'retry_btn'.tr(),
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
                                    : Text('expiration_date_text').tr(),
                                trailing: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () => context
                                      .read<TaskFormBloc>()
                                      .dateChanged(Maybe.nothing()),
                                ),
                                onTap: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: state.taskPrimitive.expireDate
                                        .getOrElse(() => DateTime.now()),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2030),
                                  );
                                  if (pickedDate != null) {
                                    // Pick the time
                                    final pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: state
                                          .taskPrimitive.expireDate
                                          .getOrElse(() => DateTime.now())
                                          .toTime(),
                                    );
                                    if (pickedTime != null) {
                                      context.read<TaskFormBloc>().dateChanged(
                                            Maybe.just(
                                              pickedDate.combine(pickedTime),
                                            ),
                                          );
                                    }
                                  }
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
                                    : Text('members_text').tr(),
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
                                    : Text('labels_text').tr(),
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
                              title: Text('add_checklist_text').tr(),
                              onTap: () async {
                                ChecklistPrimitive newChecklist;
                                if (Responsive.isLarge(context))
                                  newChecklist = await showChecklistFormDialog(
                                      context, null);
                                else
                                  newChecklist =
                                      await locator<NavigationService>()
                                          .navigateToMaterialRoute(
                                    (context) => ChecklistFormPage(),
                                    fullscreenDialog: true,
                                  );

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
                                      if (Responsive.isLarge(context))
                                        editedChecklist =
                                            await showChecklistFormDialog(
                                                context, e);
                                      else
                                        editedChecklist =
                                            await locator<NavigationService>()
                                                .navigateToMaterialRoute(
                                          (context) => ChecklistFormPage(
                                            primitive: e,
                                          ),
                                          fullscreenDialog: true,
                                        );

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
