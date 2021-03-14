import 'package:tasky/application/bloc/members_bloc.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/repositories/members_repository.dart';
import 'package:tasky/locator.dart';
import 'package:tasky/presentation/pages/task_form/widgets/members_picker_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/services/navigation_service.dart';
import 'package:easy_localization/easy_localization.dart';

/// Display a dialog that picks the members.
/// Passing an existing [List] of [members] to mark them as already selected.
/// Returns a [List] of all the selected [User]s.
Future<IList<User>?> showMembersPickerDialog(
    BuildContext context, IList<User>? members) {
  return showDialog(
    context: context,
    builder: (context) => MembersPickerDialog(members: members),
  );
}

/// Widget that display a dialog that picks members
class MembersPickerDialog extends StatefulWidget {
  final IList<User>? members;

  MembersPickerDialog({Key? key, this.members}) : super(key: key);

  @override
  _MembersPickerDialogState createState() => _MembersPickerDialogState();
}

class _MembersPickerDialogState extends State<MembersPickerDialog>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MembersBloc>(
      create: (context) => MembersBloc(
        initialValue: widget.members,
        repository: locator<MembersRepository>(),
      )..fetch(),
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(40.0),
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
        title: Text('select_members_title').tr(),
        content: BlocBuilder<MembersBloc, MembersState>(
          builder: (context, state) {
            Widget contentWidget;

            if (state.isLoading)
              contentWidget = ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 200.0,
                  maxWidth: 300.0,
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            else if (state.hasError)
              contentWidget = ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 200.0,
                  maxWidth: 300.0,
                ),
                child: Center(
                  child: Text('no_member_to_display_msg').tr(),
                ),
              );
            else
              contentWidget = SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: state.members
                        .map(
                          (e) => MembersPickerItemWidget(
                            member: e,
                            selected: state.selected.contains(e),
                            onSelected: (selected) {
                              if (selected)
                                context.read<MembersBloc>().selectMember(e);
                              else
                                context.read<MembersBloc>().deselectMember(e);
                            },
                          ),
                        )
                        .asList(),
                  ),
                ),
              );
            return AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 300),
              child: contentWidget,
            );
          },
        ),
        actions: [
          Builder(
            builder: (context) => TextButton(
              child: Text('save_btn').tr(),
              onPressed: () {
                locator<NavigationService>().pop(
                  result: context.read<MembersBloc>().state.selected,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
