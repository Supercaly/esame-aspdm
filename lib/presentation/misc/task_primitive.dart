import 'package:aspdm_project/core/ilist.dart';
import 'package:aspdm_project/core/maybe.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/presentation/misc/checklist_primitive.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:aspdm_project/domain/entities/task.dart';

/// Class representing a primitive task used
/// during the creation or editing of a task.
class TaskPrimitive extends Equatable {
  final UniqueId id;
  final String title;
  final String description;
  final Maybe<DateTime> expireDate;
  final List<Label> labels;
  final List<User> members;
  final IList<ChecklistPrimitive> checklists;
  final User author;

  /// Creates a [TaskPrimitive].
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

  /// Creates a copy of a [TaskPrimitive] with some
  /// changed fields.
  TaskPrimitive copyWith({
    String title,
    String description,
    Maybe<DateTime> expireDate,
    List<Label> labels,
    List<User> members,
    IList<ChecklistPrimitive> checklists,
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

  /// Creates an empty [TaskPrimitive].
  factory TaskPrimitive.empty() => TaskPrimitive(
        id: UniqueId.empty(),
        title: null,
        description: "",
        expireDate: Maybe.nothing(),
        labels: List<Label>.empty(),
        members: List<User>.empty(),
        checklists: IList<ChecklistPrimitive>.empty(),
        author: null,
      );

  /// Creates a [TaskPrimitive] form a [Task].
  factory TaskPrimitive.fromTask(Task task) => TaskPrimitive(
        id: task.id,
        title: task.title.value.getOrNull(),
        description: task.description.value.getOrNull(),
        expireDate: (task.expireDate != null)
            ? Maybe.just(task.expireDate)
            : Maybe.nothing(),
        labels: task.labels ?? List<Label>.empty(),
        members: task.members ?? List<User>.empty(),
        checklists: IList.from(
          task.checklists?.map((e) => ChecklistPrimitive.fromChecklist(e)),
        ),
        author: task.author,
      );

  /// Returns a [Task].
  Task toTask() => Task(
        id,
        TaskTitle(title),
        TaskDescription(description),
        labels,
        author,
        members,
        expireDate.getOrNull(),
        checklists?.map((e) => e.toChecklist())?.asList(),
        null,
        Toggle(false),
        null,
      );

  @override
  List<Object> get props => [
        id,
        title,
        description,
        expireDate,
        labels,
        members,
        checklists,
        author,
      ];

  @override
  String toString() => "TaskPrimitive{id: $id, title: $title, "
      "description: $description, expireDate: $expireDate, "
      "labels: $labels, members: $members, "
      "checklists: $checklists, author: $author}";
}
