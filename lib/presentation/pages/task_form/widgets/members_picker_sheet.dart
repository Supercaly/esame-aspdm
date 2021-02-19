import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:tasky/application/bloc/members_bloc.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/repositories/members_repository.dart';
import 'package:tasky/presentation/pages/task_form/widgets/members_picker_item_widget.dart';
import 'package:tasky/presentation/pages/task_form/widgets/sheet_notch.dart';
import 'package:flutter/material.dart';
import 'package:tasky/services/navigation_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../locator.dart';

/// Display a bottom sheet that picks the members.
/// Passing an existing [IList] of [members] to mark them as already selected.
/// Returns a [IList] of all the selected [User]s.
Future<IList<User>> showMembersPickerSheet(
  BuildContext context,
  IList<User> members,
) {
  return showSlidingBottomSheet(
    context,
    resizeToAvoidBottomInset: false,
    parentBuilder: (context, sheet) => BlocProvider<MembersBloc>(
      create: (context) => MembersBloc(
        initialValue: members,
        repository: locator<MembersRepository>(),
      )..fetch(),
      child: sheet,
    ),
    builder: (context) => SlidingSheetDialog(
      cornerRadius: 16.0,
      avoidStatusBar: true,
      cornerRadiusOnFullscreen: 0.0,
      snapSpec: SnapSpec(
        snap: true,
        initialSnap: 0.6,
        snappings: const [0.6, 1],
        positioning: SnapPositioning.relativeToAvailableSpace,
      ),
      headerBuilder: (context, state) => Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SheetNotch(),
            SizedBox(height: 8.0),
            Row(
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
                      result: context.read<MembersBloc>().state.selected,
                    );
                  },
                  child: Text('save_btn').tr(),
                ),
              ],
            ),
          ],
        ),
      ),
      builder: (context, state) => BlocBuilder<MembersBloc, MembersState>(
        builder: (context, state) {
          if (state.isLoading)
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Center(child: CircularProgressIndicator()),
            );
          else if (state.hasError)
            return Material(
              color: Theme.of(context).cardColor,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 250.0,
                  minHeight: 100.0,
                ),
                child: Center(child: Text('no_member_to_display_msg').tr()),
              ),
            );
          else
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => MembersPickerItemWidget(
                member: state.members[index],
                selected: state.selected.contains(state.members[index]),
                onSelected: (selected) {
                  if (selected)
                    context
                        .read<MembersBloc>()
                        .selectMember(state.members[index]);
                  else
                    context
                        .read<MembersBloc>()
                        .deselectMember(state.members[index]);
                },
              ),
              itemCount: state.members.length,
            );
        },
      ),
    ),
  );
}
