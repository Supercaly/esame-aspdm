import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/application/states/auth_state.dart';
import 'package:aspdm_project/presentation/theme.dart';
import 'package:aspdm_project/presentation/widgets/checklist_widget.dart';
import 'package:flutter/material.dart';
import '../task_info_page.dart';
import 'package:aspdm_project/application/bloc/task_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskInfoPageContentDesktop extends StatelessWidget {
  final Task task;
  final bool canModify;

  TaskInfoPageContentDesktop({
    Key key,
    this.task,
    this.canModify,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).brightness == Brightness.light
          ? lightThemeDesktop
          : darkThemeDesktop,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 24.0),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 490,
                child: Column(
                  children: [
                    DescriptionCard(task: task),
                    HeaderCard(task: task),
                    if (task?.checklists != null && task.checklists.isNotEmpty)
                      Column(
                        children: task.checklists
                            .map((checklist) => DisplayChecklist(
                                checklist: checklist,
                                onItemChange: canModify
                                    ? (item, value) => context
                                        .read<TaskBloc>()
                                        .completeChecklist(
                                          context
                                              .read<AuthState>()
                                              .currentUser
                                              .map((u) => u.id),
                                          checklist.id,
                                          item.id,
                                          value,
                                        )
                                    : null))
                            .asList(),
                      ),
                  ],
                ),
              ),
              Container(
                width: 490,
                child: Column(
                  children: [
                    CommentsCard(task: task),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
