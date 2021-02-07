import 'package:aspdm_project/application/bloc/members_bloc.dart';
import 'package:aspdm_project/core/ilist.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/repositories/members_repository.dart';
import 'package:aspdm_project/presentation/widgets/members_picker_item_widget.dart';
import 'package:aspdm_project/presentation/widgets/sheet_notch.dart';
import 'package:flutter/material.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../locator.dart';

/// Display a bottom sheet that picks the members.
/// Passing an existing [List] of [members] to mark them as already selected.
/// Returns a [List] of all the selected [User]s.
Future<IList<User>> showMembersPickerSheet(
    BuildContext context, IList<User> members) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => MembersPickerSheet(members: members),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
  );
}

/// Widget that display a bottom sheet that picks members
class MembersPickerSheet extends StatelessWidget {
  final IList<User> members;

  MembersPickerSheet({Key key, this.members}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        bottom: 0.0,
      ),
      child: BlocProvider<MembersBloc>(
        create: (context) => MembersBloc(
          initialValue: members,
          repository: locator<MembersRepository>(),
        )..fetch(),
        child: BlocBuilder<MembersBloc, MembersState>(
          builder: (context, state) {
            Widget contentWidget;

            if (state.isLoading)
              contentWidget = Center(child: CircularProgressIndicator());
            else if (state.hasError)
              contentWidget =
                  Center(child: Text('no_member_to_display_msg').tr());
            else
              contentWidget = CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      state.members
                          .map((e) => MembersPickerItemWidget(
                                member: e,
                                selected: state.selected.contains(e),
                                onSelected: (selected) {
                                  if (selected)
                                    context.read<MembersBloc>().selectMember(e);
                                  else
                                    context
                                        .read<MembersBloc>()
                                        .deselectMember(e);
                                },
                              ))
                          .asList(),
                    ),
                  )
                ],
              );

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SheetNotch(),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'select_members_title',
                        style: Theme.of(context).textTheme.headline6,
                      ).tr(),
                      TextButton(
                        onPressed: () {
                          locator<NavigationService>().pop(
                            result: state.selected,
                          );
                        },
                        child: Text('save_btn').tr(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.0),
                Expanded(child: contentWidget),
              ],
            );
          },
        ),
      ),
    );
  }
}
