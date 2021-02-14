import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:equatable/equatable.dart';

/// Class representing a checklist in a task.
class Checklist extends Equatable {
  /// Id of the checklist
  final UniqueId id;

  /// Title of the checklist.
  final ChecklistTitle title;

  /// Items of the checklist.
  final IList<ChecklistItem> items;

  Checklist(this.id, this.title, this.items);

  @override
  List<Object?> get props => [id, title, items];

  @override
  String toString() => "Checklist{id: $id, title: $title, items: $items}";
}

/// Class representing a single item of a checklist.
class ChecklistItem extends Equatable {
  /// Id of the checklist item
  final UniqueId id;

  /// title of the item.
  final ItemText item;

  /// Whether the item is marked as completed or not.
  final Toggle complete;

  ChecklistItem(this.id, this.item, this.complete);

  @override
  List<Object?> get props => [id, item, complete];

  @override
  String toString() =>
      "ChecklistItem{id: $id, item: $item, complete: $complete}";
}
