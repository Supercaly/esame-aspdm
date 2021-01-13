import 'package:aspdm_project/infrastructure/models/checklist_model.dart';
import 'package:aspdm_project/infrastructure/models/comment_model.dart';
import 'package:aspdm_project/infrastructure/models/label_model.dart';
import 'package:aspdm_project/infrastructure/models/user_model.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel extends Equatable {
  @JsonKey(
    name: "_id",
    required: true,
    disallowNullValue: true,
  )
  final String id;

  @JsonKey(required: true, disallowNullValue: true)
  final String title;

  @JsonKey(
    name: "creation_date",
    required: true,
    disallowNullValue: true,
  )
  final DateTime creationDate;

  @JsonKey(nullable: true)
  final String description;

  final List<LabelModel> labels;

  @JsonKey(required: true, disallowNullValue: true)
  final UserModel author;

  final List<UserModel> members;

  @JsonKey(name: "expire_date")
  final DateTime expireDate;

  final List<ChecklistModel> checklists;

  final List<CommentModel> comments;

  @JsonKey(defaultValue: false)
  final bool archived;

  TaskModel(
    this.id,
    this.title,
    this.description,
    this.labels,
    this.author,
    this.members,
    this.expireDate,
    this.checklists,
    this.comments,
    this.archived,
    this.creationDate,
  );

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  factory TaskModel.fromTask(Task task) => TaskModel(
        task.id.value.getOrNull(),
        task.title.value.getOrNull(),
        task.description.value.getOrNull(),
        task.labels?.map((e) => LabelModel.fromLabel(e))?.toList(),
        (task.author == null) ? null : UserModel.fromUser(task.author),
        task.members?.map((e) => UserModel.fromUser(e))?.toList(),
        task.expireDate,
        task.checklists?.map((e) => ChecklistModel.fromChecklist(e))?.toList(),
        task.comments?.map((e) => CommentModel.fromComment(e))?.toList(),
        task.archived.value.getOrElse((_) => false),
        task.creationDate,
      );

  Task toTask() => Task(
        UniqueId(id),
        TaskTitle(title),
        TaskDescription(description),
        labels?.map((e) => e.toLabel())?.toList(),
        author?.toUser(),
        members?.map((e) => e.toUser())?.toList(),
        expireDate,
        checklists?.map((e) => e.toChecklist())?.toList(),
        comments?.map((e) => e.toComment())?.toList(),
        Toggle(archived),
        creationDate,
      );

  @override
  List<Object> get props => [
        id,
        title,
        description,
        labels,
        author,
        members,
        expireDate,
        checklists,
        comments,
        archived,
        creationDate,
      ];
}
