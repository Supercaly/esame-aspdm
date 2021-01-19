import 'package:aspdm_project/application/bloc/task_form_bloc.dart';
import 'package:aspdm_project/domain/entities/checklist.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/presentation/misc/checklist_primitive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

/// Widget that displays a single [Checklist].
class DisplayChecklist extends StatefulWidget {
  /// The [Checklist] object to display.
  final Checklist checklist;

  /// Method called every time a [ChecklistItem] change.
  /// This method has the [ChecklistItem] and [bool] value.
  /// If this is `null` the widget will be un-modifiable by
  /// the current user.
  final void Function(ChecklistItem, Toggle) onItemChange;

  const DisplayChecklist({
    Key key,
    this.checklist,
    this.onItemChange,
  })  : assert(checklist != null),
        super(key: key);

  @override
  _DisplayChecklistState createState() => _DisplayChecklistState();
}

class _DisplayChecklistState extends State<DisplayChecklist> {
  bool _showItems;

  @override
  void initState() {
    super.initState();

    _showItems = true;
  }

  @override
  Widget build(BuildContext context) {
    final hasItems =
        widget.checklist.items != null && widget.checklist.items.isNotEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(FeatherIcons.checkCircle),
              SizedBox(width: 8.0),
              Text(
                widget.checklist.title.value.getOrElse((_) => ""),
                style: Theme.of(context).textTheme.headline6,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(_showItems
                        ? FeatherIcons.chevronUp
                        : FeatherIcons.chevronDown),
                    onPressed: () {
                      setState(() {
                        _showItems = !_showItems;
                      });
                    },
                  ),
                ),
              ),
            ]),
            SizedBox(height: 8.0),
            LinearProgressIndicator(
              value: _getChecklistProgress(widget.checklist.items),
              backgroundColor: Color(0xFFE5E5E5),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B24A)),
            ),
            SizedBox(height: 8.0),
            if (_showItems && hasItems)
              Column(
                children: widget.checklist.items
                    .map((item) => Row(
                          children: [
                            Checkbox(
                              value: item.complete.value.getOrCrash(),
                              onChanged: (widget.onItemChange != null)
                                  ? (value) => widget.onItemChange
                                      ?.call(item, Toggle(value))
                                  : null,
                            ),
                            Text(item.item.value.getOrElse((_) => "-")),
                          ],
                        ))
                    .toList(),
              )
          ],
        ),
      ),
    );
  }

  double _getChecklistProgress(List<ChecklistItem> items) {
    if (items == null || items.isEmpty) return 0.0;
    final checkedItems =
        items.where((element) => element.complete.value.getOrCrash());
    if (checkedItems.isEmpty) return 0.0;
    return checkedItems.length / items.length;
  }
}

class EditChecklist extends StatelessWidget {
  final ChecklistPrimitive checklist;

  const EditChecklist({Key key, this.checklist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(FeatherIcons.checkCircle),
              SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  checklist.title.value.getOrNull() ?? "",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () =>
                    context.read<TaskFormBloc>().removeChecklist(checklist),
              ),
            ]),
            SizedBox(height: 8.0),
            Column(
              children: checklist.items
                  .map((e) => CheckboxFormItemWidget(
                      item: e.value.getOrNull() ?? ""))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}

class CheckboxFormItemWidget extends StatelessWidget {
  final String item;

  CheckboxFormItemWidget({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: false,
          onChanged: null,
        ),
        SizedBox(width: 8.0),
        Expanded(child: Text(item)),
      ],
    );
  }
}
