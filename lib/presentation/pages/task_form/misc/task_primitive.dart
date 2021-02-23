import 'package:tasky/core/ilist.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/entities/label.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/presentation/pages/task_form/misc/checklist_primitive.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tasky/domain/entities/task.dart';

/// Class representing a primitive task used
/// during the creation or editing of a task.
class TaskPrimitive extends Equatable {
  final UniqueId id;
  final String title;
  final String description;
  final Maybe<DateTime> expireDate;
  final IList<Label> labels;
  final IList<User> members;
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
    IList<Label> labels,
    IList<User> members,
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
        labels: IList<Label>.empty(),
        members: IList<User>.empty(),
        checklists: IList<ChecklistPrimitive>.empty(),
        author: null,
      );

  /// Creates a [TaskPrimitive] form a [Task].
  factory TaskPrimitive.fromTask(Task task) => TaskPrimitive(
        id: task.id,
        title: task.title.value.getOrNull(),
        description: task.description.getOrNull()?.value?.getOrNull(),
        expireDate: task.expireDate.flatMap((value) => value.value.toMaybe()),
        labels: task.labels,
        members: task.members,
        checklists:
            task.checklists.map((e) => ChecklistPrimitive.fromChecklist(e)),
        author: task.author,
      );

  /// Returns a [Task].
  Task toTask() => Task(
        id: id,
        title: TaskTitle(title),
        description: (description != null && description.isNotEmpty)
            ? Maybe.just(TaskDescription(description))
            : Maybe.nothing(),
        labels: labels,
        author: author,
        members: members,
        expireDate: expireDate.map((value) => ExpireDate(value)),
        checklists: checklists.map((e) => e.toChecklist()),
        comments: IList.empty(),
        archived: Toggle(false),
        creationDate: CreationDate(null),
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
