import 'package:tasky/application/bloc/auth_bloc.dart';
import 'package:tasky/application/bloc/task_form_bloc.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/repositories/task_form_repository.dart';
import 'package:tasky/locator.dart';
import 'package:tasky/presentation/pages/task_form/widgets/checklist_form_dialog.dart';
import 'package:tasky/presentation/pages/task_form/widgets/date_picker_widget.dart';
import 'package:tasky/presentation/pages/task_form/widgets/label_picker_widget.dart';
import 'package:tasky/presentation/pages/task_form/misc/checklist_primitive.dart';
import 'package:tasky/presentation/pages/task_form/checklist_form_page.dart';
import 'package:tasky/presentation/pages/task_form/widgets/edit_checklist.dart';
import 'package:tasky/presentation/pages/task_form/widgets/members_picker_widget.dart';
import 'package:tasky/presentation/widgets/responsive.dart';
import 'package:tasky/presentation/pages/task_form/widgets/task_form_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:tasky/services/navigation_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../../theme.dart';
import 'package:easy_localization/easy_localization.dart';

class TaskFormPage extends StatelessWidget {
  final Maybe<Task> task;

  const TaskFormPage({
    Key? key,
    required this.task,
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
                  if (_formKey.currentState!.validate())
                    await context.read<TaskFormBloc>().saveTask(context
                        .read<AuthBloc>()
                        .state
                        .user
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
                if (_formKey.currentState!.validate())
                  await context.read<TaskFormBloc>().saveTask(context
                      .read<AuthBloc>()
                      .state
                      .user
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
                            DatePickerWidget(),
                            MembersPickerWidget(),
                            LabelPickerWidget(),
                            ListTile(
                              leading: Icon(FeatherIcons.checkCircle),
                              title: Text('add_checklist_text').tr(),
                              onTap: () async {
                                ChecklistPrimitive? newChecklist;
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
                                      ChecklistPrimitive? editedChecklist;
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
