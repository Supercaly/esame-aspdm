import 'package:flutter/foundation.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/infrastructure/models/checklist_model.dart';
import 'package:tasky/infrastructure/models/comment_model.dart';
import 'package:tasky/infrastructure/models/label_model.dart';
import 'package:tasky/infrastructure/models/user_model.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
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

  TaskModel({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.labels,
    @required this.author,
    @required this.members,
    @required this.expireDate,
    @required this.checklists,
    @required this.comments,
    @required this.archived,
    @required this.creationDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  factory TaskModel.fromTask(Task task) => TaskModel(
        id: task.id.value.getOrNull(),
        title: task.title.value.getOrNull(),
        description: task.description.value.getOrNull(),
        labels: task.labels?.map((e) => LabelModel.fromLabel(e))?.asList(),
        author: (task.author == null) ? null : UserModel.fromUser(task.author),
        members: task.members?.map((e) => UserModel.fromUser(e))?.asList(),
        expireDate: task.expireDate,
        checklists: task.checklists
            ?.map((e) => ChecklistModel.fromChecklist(e))
            ?.asList(),
        comments:
            task.comments?.map((e) => CommentModel.fromComment(e))?.asList(),
        archived: task.archived.value.getOrElse((_) => false),
        creationDate: task.creationDate,
      );

  Task toTask() => Task(
        id: UniqueId(id),
        title: TaskTitle(title),
        description: TaskDescription(description),
        labels: IList.from(labels?.map((e) => e.toLabel())),
        author: author?.toUser(),
        members: IList.from(members?.map((e) => e.toUser())),
        expireDate: expireDate,
        checklists: IList.from(checklists?.map((e) => e.toChecklist())),
        comments: IList.from(comments?.map((e) => e.toComment())),
        archived: Toggle(archived),
        creationDate: creationDate,
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
