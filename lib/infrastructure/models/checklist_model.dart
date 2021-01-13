import 'package:aspdm_project/domain/entities/checklist.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'checklist_model.g.dart';

@JsonSerializable()
class ChecklistModel extends Equatable {
  @JsonKey(
    name: "_id",
    required: true,
    disallowNullValue: true,
  )
  final String id;

  final String title;

  final List<ChecklistItemModel> items;

  ChecklistModel(this.id, this.title, this.items);

  factory ChecklistModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistModelToJson(this);

  factory ChecklistModel.fromChecklist(Checklist checklist) => ChecklistModel(
        checklist.id.value.getOrNull(),
        checklist.title.value.getOrNull(),
        checklist.items
            ?.map((e) => ChecklistItemModel.fromChecklistItem(e))
            ?.toList(),
      );

  Checklist toChecklist() => Checklist(
        UniqueId(id),
        ItemText(title),
        items?.map((e) => e.toChecklistItem())?.toList(),
      );

  @override
  List<Object> get props => [id, title, items];
}

@JsonSerializable()
class ChecklistItemModel extends Equatable {
  @JsonKey(
    name: "_id",
    required: true,
    disallowNullValue: true,
  )
  final String id;

  final String item;

  @JsonKey(defaultValue: false)
  final bool complete;

  ChecklistItemModel(this.id, this.item, this.complete);

  factory ChecklistItemModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistItemModelToJson(this);

  factory ChecklistItemModel.fromChecklistItem(ChecklistItem item) =>
      ChecklistItemModel(
        item.id.value.getOrNull(),
        item.item.value.getOrNull(),
        item.complete.value.getOrNull(),
      );

  ChecklistItem toChecklistItem() => ChecklistItem(
        UniqueId(id),
        ItemText(item),
        Toggle(complete),
      );

  @override
  List<Object> get props => [id, item, complete];
}
