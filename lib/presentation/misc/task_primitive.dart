import 'package:aspdm_project/domain/entities/checklist.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:flutter/foundation.dart';
import 'package:aspdm_project/domain/entities/task.dart';

class TaskPrimitive {
  final UniqueId id;
  final TaskTitle title;
  final TaskDescription description;
  final DateTime expireDate;
  final List<Label> labels;
  final List<User> members;
  final List<Checklist> checklists;
  final User author;

  TaskPrimitive({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.expireDate,
    @required this.labels,
    @required this.members,
    @required this.checklists,
    @required this.author,
  });

  // TODO: Implement those
  Task toTask() => null;

  TaskPrimitive copyWith({
    TaskTitle title,
    TaskDescription description,
    DateTime expireDate,
    List<Label> labels,
    List<User> members,
    List<Checklist> checklists,
  }) =>
      TaskPrimitive(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        expireDate: expireDate ?? this.expireDate,
        labels: labels ?? this.labels,
        members: members ?? this.members,
        checklists: checklists ?? this.checklists,
        author: author,
      );

  factory TaskPrimitive.empty() => TaskPrimitive(
        id: UniqueId.empty(),
        title: TaskTitle.empty(),
        description: TaskDescription.empty(),
        expireDate: null,
        labels: List<Label>.empty(),
        members: List<User>.empty(),
        checklists: List<Checklist>.empty(),
        author: null,
      );

  factory TaskPrimitive.fromTask(Task task) => TaskPrimitive(
        id: task.id,
        title: task.title,
        description: task.description,
        expireDate: task.expireDate,
        labels: task.labels ?? List<Label>.empty(),
        members: task.members ?? List<User>.empty(),
        checklists: task.checklists ?? List<Checklist>.empty(),
        author: task.author,
      );
}
