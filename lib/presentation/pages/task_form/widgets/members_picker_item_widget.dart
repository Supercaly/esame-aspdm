import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/presentation/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

/// Widget that display a single item of a member picker
/// This Widget show a single [member] with his avatar, name and email
/// and a check icon if it's [selected].
/// When the user presses on it [onSelected] will be called with
/// the new value (true if previously the [selected] was false, false
/// otherwise).
class MembersPickerItemWidget extends StatelessWidget {
  final User member;
  final bool selected;
  final void Function(bool value) onSelected;

  MembersPickerItemWidget({
    Key key,
    @required this.member,
    this.selected = false,
    this.onSelected,
  })  : assert(member != null),
        assert(selected != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: () => onSelected?.call(!selected),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 8.0,
          ),
          width: double.maxFinite,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserAvatar(
                user: member,
                size: 40.0,
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    member.name.value.fold(
                        (left) => SizedBox.shrink(),
                        (right) => Text(
                              right,
                              style: Theme.of(context).textTheme.bodyText1,
                            )),
                    member.email.value.fold(
                        (left) => SizedBox.shrink(), (right) => Text(right)),
                  ],
                ),
              ),
              SizedBox(width: 16.0),
              selected ? Icon(FeatherIcons.check) : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
