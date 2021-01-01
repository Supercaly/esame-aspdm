import 'package:aspdm_project/domain/entities/checklist.dart';
import 'package:json_annotation/json_annotation.dart';

part 'checklist_model.g.dart';

@JsonSerializable()
class ChecklistModel {
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
        checklist.id,
        checklist.title,
        checklist.items
            ?.map((e) => ChecklistItemModel.fromChecklistItem(e))
            ?.toList(),
      );

  Checklist toChecklist() => Checklist(
        id,
        title,
        items?.map((e) => e.toChecklistItem())?.toList(),
      );
}

@JsonSerializable()
class ChecklistItemModel {
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
      ChecklistItemModel(item.id, item.item, item.complete);

  ChecklistItem toChecklistItem() => ChecklistItem(id, item, complete);
}
