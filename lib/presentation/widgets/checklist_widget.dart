import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/checklist.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/presentation/pages/task_form/misc/checklist_primitive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

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
              value: getChecklistProgress(widget.checklist.items),
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
                            Text(
                              item.item.value.getOrElse((_) => "-"),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    decoration: item.complete.value.fold(
                                      (_) => null,
                                      (c) =>
                                          c ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                            ),
                          ],
                        ))
                    .asList(),
              )
          ],
        ),
      ),
    );
  }

  @visibleForTesting
  double getChecklistProgress(IList<ChecklistItem> items) {
    if (items == null || items.isEmpty) return 0.0;
    final checkedItems =
        items.filter((element) => element.complete.value.getOrCrash());
    if (checkedItems.isEmpty) return 0.0;
    return checkedItems.length / items.length;
  }
}

// TODO: Split in his own file
/// Widget that displays a single [ChecklistPrimitive].
/// This widget is used in the [TaskFormPage] during the
/// creation or edit of a task.
class EditChecklist extends StatelessWidget {
  /// The [ChecklistPrimitive] to display.
  final ChecklistPrimitive primitive;

  /// Callback called when the user taps on the card.
  final VoidCallback onTap;

  /// Callback called when the user taps on the remove button.
  final VoidCallback onRemove;

  const EditChecklist({
    Key key,
    this.primitive,
    this.onTap,
    this.onRemove,
  })  : assert(primitive != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
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
                    primitive.title ?? "",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onRemove,
                ),
              ]),
              SizedBox(height: 8.0),
              Column(
                children: primitive.items
                    .map((e) => Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: null,
                            ),
                            SizedBox(width: 8.0),
                            Expanded(child: Text(e.value.getOrNull() ?? "")),
                          ],
                        ))
                    .asList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
