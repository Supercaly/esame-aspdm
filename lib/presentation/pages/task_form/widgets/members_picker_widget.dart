import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:tasky/application/bloc/task_form_bloc.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/presentation/pages/task_form/widgets/members_picker_dialog.dart';
import 'package:tasky/presentation/pages/task_form/widgets/members_picker_sheet.dart';
import 'package:tasky/presentation/widgets/responsive.dart';
import 'package:tasky/presentation/widgets/user_avatar.dart';
import 'package:easy_localization/easy_localization.dart';

/// Widget that lets the user pick the members.
class MembersPickerWidget extends StatelessWidget {
  const MembersPickerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskFormBloc, TaskFormState>(
      buildWhen: (p, c) => p.taskPrimitive.members != c.taskPrimitive.members,
      builder: (context, state) => ListTile(
        leading: Icon(FeatherIcons.users),
        title: (state.taskPrimitive.members.isNotEmpty)
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
          IList<User>? selectedMembers;
          if (Responsive.isSmall(context))
            selectedMembers = await showMembersPickerSheet(
              context,
              state.taskPrimitive.members,
            );
          else
            selectedMembers = await showMembersPickerDialog(
              context,
              state.taskPrimitive.members,
            );
          if (selectedMembers != null)
            context.read<TaskFormBloc>().membersChanged(selectedMembers);
        },
      ),
    );
  }
}
