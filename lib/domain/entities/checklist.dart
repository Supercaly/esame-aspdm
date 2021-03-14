import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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

  /// Create a new [Checklist] with all his values.
  const Checklist({
    required this.id,
    required this.title,
    required this.items,
  });

  /// Create a new [Checklist] with some of his values.
  /// If a value is not specified a safe default
  /// will be used instead.
  @visibleForTesting
  factory Checklist.test({
    UniqueId? id,
    ChecklistTitle? title,
    IList<ChecklistItem>? items,
  }) =>
      Checklist(
        id: id ?? UniqueId.empty(),
        title: title ?? ChecklistTitle(null),
        items: items ?? IList.empty(),
      );

  @override
  List<Object> get props => [id, title, items];

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

  /// Create a new [ChecklistItem] with all his values.
  const ChecklistItem({
    required this.id,
    required this.item,
    required this.complete,
  });

  /// Create a new [ChecklistItem] with some of his values.
  /// If a value is not specified a safe default
  /// will be used instead.
  @visibleForTesting
  factory ChecklistItem.test({
    UniqueId? id,
    ItemText? item,
    Toggle? complete,
  }) =>
      ChecklistItem(
        id: id ?? UniqueId.empty(),
        item: item ?? ItemText(null),
        complete: complete ?? Toggle(false),
      );

  @override
  List<Object> get props => [id, item, complete];

  @override
  String toString() =>
      "ChecklistItem{id: $id, item: $item, complete: $complete}";
}
