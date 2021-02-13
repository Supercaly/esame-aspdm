import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/checklist.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:equatable/equatable.dart';

/// Class representing a primitive checklist used
/// during the creation or editing of a task.
class ChecklistPrimitive extends Equatable {
  final String title;
  final IList<ItemText> items;

  /// Creates a [ChecklistPrimitive].
  ChecklistPrimitive({this.title, this.items});

  /// Creates an empty [ChecklistPrimitive].
  factory ChecklistPrimitive.empty() => ChecklistPrimitive(
        title: null,
        items: IList<ItemText>.empty(),
      );

  /// Creates a copy of a [ChecklistPrimitive] with some changed fields.
  ChecklistPrimitive copyWith({String title, IList<ItemText> items}) =>
      ChecklistPrimitive(
        title: title ?? this.title,
        items: items ?? this.items,
      );

  /// Creates a [ChecklistPrimitive] form a [Checklist].
  factory ChecklistPrimitive.fromChecklist(Checklist checklist) =>
      ChecklistPrimitive(
        title: checklist.title.value.getOrNull(),
        items: checklist.items?.map((e) => e.item),
      );

  /// Returns a [Checklist].
  Checklist toChecklist() => Checklist(
        UniqueId.empty(),
        ChecklistTitle(title),
        items.map(
          (e) => ChecklistItem(
            UniqueId.empty(),
            e,
            Toggle(false),
          ),
        ),
      );

  @override
  List<Object> get props => [title, items];

  @override
  String toString() => "ChecklistPrimitive{title: $title, items: $items}";
}
