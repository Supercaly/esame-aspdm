import 'package:aspdm_project/domain/entities/label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

/// Widget that display a single item of a label picker
/// This Widget show a box of [label]'s color, the [label]'s label
/// and a check icon if it's [selected].
/// When the user presses on it [onSelected] will be called with
/// the new value (true if previously the [selected] was false, false
/// otherwise).
class LabelPickerItemWidget extends StatelessWidget {
  final Label label;
  final bool selected;
  final void Function(bool value) onSelected;

  LabelPickerItemWidget({
    Key key,
    this.label,
    this.selected = false,
    this.onSelected,
  })  : assert(label != null),
        assert(selected != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        width: double.maxFinite,
        child: Material(
          color: label.color,
          borderRadius: BorderRadius.circular(8.0),
          child: InkWell(
            onTap: () => onSelected?.call(!selected),
            borderRadius: BorderRadius.circular(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label.label.value.getOrNull() ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  selected
                      ? Icon(
                          FeatherIcons.check,
                          color: Colors.white,
                        )
                      : Container(width: 24.0, height: 24.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
