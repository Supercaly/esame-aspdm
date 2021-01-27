import 'package:aspdm_project/core/maybe.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/repositories/task_form_repository.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/presentation/misc/checklist_primitive.dart';
import 'package:aspdm_project/presentation/misc/task_primitive.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit class used to manage the state of the task form page.
class TaskFormBloc extends Cubit<TaskFormState> {
  final TaskFormRepository repository;

  /// Creates a [TaskFormBloc] form the old [Task].
  TaskFormBloc({
    @required Maybe<Task> oldTask,
    @required this.repository,
  }) : super(TaskFormState.initial(oldTask));

  /// Tells the [TaskFormBloc] that the title is changed.
  void titleChanged(String value) {
    emit(
      state.copyWith(
        taskPrimitive: state.taskPrimitive.copyWith(
          title: value,
        ),
      ),
    );
  }

  /// Tells the [TaskFormBloc] that the description is changed.
  void descriptionChanged(String value) {
    emit(state.copyWith(
      taskPrimitive: state.taskPrimitive.copyWith(
        description: value,
      ),
    ));
  }

  /// Tells the [TaskFormBloc] that the expire date is changed.
  void dateChanged(Maybe<DateTime> value) {
    emit(
      state.copyWith(
        taskPrimitive: state.taskPrimitive.copyWith(expireDate: value),
      ),
    );
  }

  /// Tells the [TaskFormBloc] that the members list is changed.
  void membersChanged(List<User> value) {
    emit(state.copyWith(
        taskPrimitive: state.taskPrimitive.copyWith(members: value)));
  }

  /// Tells the [TaskFormBloc] that the labels list is changed.
  void labelsChanged(List<Label> value) {
    emit(state.copyWith(
        taskPrimitive: state.taskPrimitive.copyWith(labels: value)));
  }

  /// Tells the [TaskFormBloc] that the a new [ChecklistPrimitive] is added
  /// to the checklists list.
  void addChecklist(ChecklistPrimitive value) {
    emit(
      state.copyWith(
        taskPrimitive: state.taskPrimitive.copyWith(
          checklists: state.taskPrimitive.checklists.addImmutable(value),
        ),
      ),
    );
  }

  /// Tells the [TaskFormBloc] that the given [ChecklistPrimitive] is removed
  /// from the checklists list.
  void removeChecklist(ChecklistPrimitive value) {
    emit(
      state.copyWith(
        taskPrimitive: state.taskPrimitive.copyWith(
          checklists: state.taskPrimitive.checklists.removeImmutable(value),
        ),
      ),
    );
  }

  /// Tells the [TaskFormBloc] that the old [ChecklistPrimitive] is changed
  /// in the checklists list.
  void editChecklist(ChecklistPrimitive old, ChecklistPrimitive value) {
    emit(
      state.copyWith(
        taskPrimitive: state.taskPrimitive.copyWith(
          checklists:
              state.taskPrimitive.checklists.updateImmutable(old, value),
        ),
      ),
    );
  }

  /// Tells the [TaskFormBloc] to save the changes made to the [Task]
  /// or to create a new one depending on the mode.
  Future<void> saveTask(UniqueId userId) async {
    emit(state.copyWith(isSaving: true, hasError: false));
    if (state.mode == TaskFormMode.creating) {
      (await repository.saveNewTask(state.taskPrimitive.toTask(), userId)).fold(
        (left) => emit(state.copyWith(
          saved: false,
          isSaving: false,
          hasError: true,
        )),
        (right) => emit(state.copyWith(
          saved: true,
          isSaving: false,
        )),
      );
    } else {
      (await repository.updateTask(state.taskPrimitive.toTask())).fold(
        (left) => emit(state.copyWith(
          saved: false,
          isSaving: false,
          hasError: true,
        )),
        (right) => emit(state.copyWith(
          saved: true,
          isSaving: false,
        )),
      );
    }
  }
}

/// Enum representing all the possible modes
/// of the task form page
enum TaskFormMode {
  /// The page is creating a new task
  creating,

  /// The page is editing an existing task
  editing,
}

/// Class with the state of the [TaskFormBloc].
class TaskFormState extends Equatable {
  final TaskPrimitive taskPrimitive;
  final bool hasError;
  final bool isSaving;
  final bool saved;
  final TaskFormMode mode;

  @visibleForTesting
  TaskFormState({
    @required this.taskPrimitive,
    @required this.hasError,
    @required this.isSaving,
    @required this.saved,
    @required this.mode,
  });

  /// Creates a [TaskFormState] from the old [Task].
  factory TaskFormState.initial(Maybe<Task> task) => task.fold(
        () => TaskFormState(
          taskPrimitive: TaskPrimitive.empty(),
          hasError: false,
          isSaving: false,
          saved: false,
          mode: TaskFormMode.creating,
        ),
        (task) => TaskFormState(
          taskPrimitive: TaskPrimitive.fromTask(task),
          hasError: false,
          isSaving: false,
          saved: false,
          mode: TaskFormMode.editing,
        ),
      );

  /// Creates a copy of a [TaskFormState] with some different fields.
  TaskFormState copyWith({
    TaskPrimitive taskPrimitive,
    bool isSaving,
    bool saved,
    bool hasError,
  }) =>
      TaskFormState(
        taskPrimitive: taskPrimitive ?? this.taskPrimitive,
        isSaving: isSaving ?? this.isSaving,
        saved: saved ?? this.saved,
        mode: this.mode,
        hasError: hasError ?? this.hasError,
      );

  @override
  List<Object> get props => [taskPrimitive, isSaving, mode];

  @override
  String toString() => "TaskFormState{taskPrimitive: $taskPrimitive, "
      "mode: $mode, hasError: $hasError, "
      "isSaving: $isSaving, saved: $saved}";
}

// TODO: Optimize all this list shenanigans.
extension ListX<E> on List<E> {
  List<E> addImmutable(E element) {
    if (this.isEmpty) return List.of([element]);
    List<E> result = List<E>.empty(growable: true);
    result.addAll(this);
    result.add(element);
    return result;
  }

  List<E> removeImmutable(E element) {
    if (this.isEmpty) return List.empty();
    List<E> result = List<E>.empty(growable: true);
    result.addAll(this);
    result.remove(element);
    return result;
  }

  List<E> removeAtImmutable(int index) {
    if (this.isEmpty) return List.empty();
    List<E> result = List<E>.empty(growable: true);
    result.addAll(this);
    result.removeAt(index);
    return result;
  }

  List<E> updatedImmutable(int index, E element) {
    if (this.isEmpty) return List.empty();
    List<E> result = List<E>.empty(growable: true);
    result.addAll(this);
    result[index] = element;
    return result;
  }

  List<E> updateImmutable(E old, E element) {
    if (this.isEmpty) return List.empty();
    List<E> result = List<E>.empty(growable: true);
    result.addAll(this);
    final idx = result.indexOf(old);
    if (idx >= 0) result[idx] = element;
    return result;
  }
}
