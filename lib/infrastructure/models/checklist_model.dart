import 'package:flutter/foundation.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/checklist.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
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

  ChecklistModel({
    @required this.id,
    @required this.title,
    @required this.items,
  });

  factory ChecklistModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistModelToJson(this);

  factory ChecklistModel.fromChecklist(Checklist checklist) => ChecklistModel(
        id: checklist.id.value.getOrNull(),
        title: checklist.title.value.getOrNull(),
        items: checklist.items
            ?.map((e) => ChecklistItemModel.fromChecklistItem(e))
            ?.asList(),
      );

  Checklist toChecklist() => Checklist(
        id: UniqueId(id),
        title: ChecklistTitle(title),
        items: IList.from(items?.map((e) => e.toChecklistItem())),
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

  ChecklistItemModel({
    @required this.id,
    @required this.item,
    @required this.complete,
  });

  factory ChecklistItemModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistItemModelToJson(this);

  factory ChecklistItemModel.fromChecklistItem(ChecklistItem item) =>
      ChecklistItemModel(
        id: item.id.value.getOrNull(),
        item: item.item.value.getOrNull(),
        complete: item.complete.value.getOrNull(),
      );

  ChecklistItem toChecklistItem() => ChecklistItem(
        id: UniqueId(id),
        item: ItemText(item),
        complete: Toggle(complete),
      );

  @override
  List<Object> get props => [id, item, complete];
}
