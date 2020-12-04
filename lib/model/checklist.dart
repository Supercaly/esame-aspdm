import 'package:equatable/equatable.dart';

/// Class representing a checklist in a task.
class Checklist extends Equatable {
  /// Title of the checklist.
  final String title;

  /// Items of the checklist.
  final List<ChecklistItem> items;

  Checklist([this.title, this.items]);

  @override
  List<Object> get props => [title, items];
}

/// Class representing a single item of a checklist.
class ChecklistItem extends Equatable {
  /// title of the item.
  final String text;

  /// Whether the item is marked as completed or not.
  final bool checked;

  ChecklistItem(this.text, this.checked);

  @override
  List<Object> get props => [text, checked];
}
