import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'checklist.g.dart';

/// Class representing a checklist in a task.
@JsonSerializable()
class Checklist extends Equatable {
  /// Title of the checklist.
  final String title;

  /// Items of the checklist.
  final List<ChecklistItem> items;

  Checklist(this.title, this.items);

  /// Creates a new [Checklist] from json data.
  factory Checklist.fromJson(Map<String, dynamic> json) =>
      _$ChecklistFromJson(json);

  /// Converts this [Checklist] to json data.
  Map<String, dynamic> toJson() => _$ChecklistToJson(this);

  @override
  List<Object> get props => [title, items];
}

/// Class representing a single item of a checklist.
@JsonSerializable()
class ChecklistItem extends Equatable {
  /// title of the item.
  final String text;

  /// Whether the item is marked as completed or not.
  @JsonKey(defaultValue: false)
  final bool checked;

  ChecklistItem(this.text, this.checked);

  /// Creates a new [ChecklistItem] from json data.
  factory ChecklistItem.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemFromJson(json);

  /// Converts this [ChecklistItem] to json data.
  Map<String, dynamic> toJson() => _$ChecklistItemToJson(this);

  @override
  List<Object> get props => [text, checked];
}
