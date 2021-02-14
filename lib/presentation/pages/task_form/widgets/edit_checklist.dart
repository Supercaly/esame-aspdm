import 'package:tasky/presentation/pages/task_form/misc/checklist_primitive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

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
