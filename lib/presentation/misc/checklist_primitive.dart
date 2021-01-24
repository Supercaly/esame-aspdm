import 'package:aspdm_project/domain/entities/checklist.dart';
import 'package:aspdm_project/domain/values/task_values.dart';

class ChecklistPrimitive {
  final ChecklistTitle title;
  final List<ItemText> items;

  ChecklistPrimitive({this.title, this.items});

  factory ChecklistPrimitive.empty() => ChecklistPrimitive(
        title: ChecklistTitle(""),
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

  @override
  String toString() => "ChecklistPrimitive{title: $title, items: $items}";
}
