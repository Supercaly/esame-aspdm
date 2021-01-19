import 'package:aspdm_project/domain/entities/checklist.dart';
import 'package:aspdm_project/domain/values/task_values.dart';

class ChecklistPrimitive {
  final ItemText title;
  final List<ItemText> items;

  ChecklistPrimitive({this.title, this.items});

  factory ChecklistPrimitive.empty() => ChecklistPrimitive(
        // TODO: Replace with empty constructor
        title: ItemText(""),
        items: List<ItemText>.empty(),
      );

  factory ChecklistPrimitive.fromChecklist(Checklist checklist) =>
      ChecklistPrimitive(
        title: checklist.title,
        items: checklist.items?.map((e) => e.item)?.toList() ??
            List<ItemText>.empty(),
      );

  // TODO: Implement this
  Checklist toChecklist() => null;
}
