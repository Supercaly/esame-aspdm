import 'package:aspdm_project/core/maybe.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/presentation/misc/checklist_primitive.dart';
import 'package:aspdm_project/presentation/misc/task_primitive.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit class used to manage the state of the task form page.
class TaskFormBloc extends Cubit<TaskFormState> {
  /// Creates a [TaskFormBloc] form the old [Task].
  TaskFormBloc(Maybe<Task> oldTask)
      : super(TaskFormState.initial(oldTask.fold(
          () => TaskPrimitive.empty(),
          (task) => TaskPrimitive.fromTask(task),
        )));

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
  /// or to create a new one.
  Future<void> saveTask() async {
    // TODO: Implement save/update mechanic
    print("EditTaskBloc.saveTask: Saving task...");
    print("EditTaskBloc.saveTask: ${state.taskPrimitive}");
    emit(state.copyWith(isSaving: true));
    await Future.delayed(Duration(seconds: 5));
    emit(state.copyWith(isSaving: false));
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
  final bool isSaving;
  final bool isInitial;

  @visibleForTesting
  TaskFormState(this.taskPrimitive, this.isSaving, this.isInitial);

  factory TaskFormState.initial(TaskPrimitive primitive) =>
      TaskFormState(primitive, false, true);

  TaskFormState copyWith({TaskPrimitive taskPrimitive, bool isSaving}) =>
      TaskFormState(
        taskPrimitive ?? this.taskPrimitive,
        isSaving ?? this.isSaving,
        false,
      );

  @override
  List<Object> get props => [taskPrimitive, isSaving, isInitial];

  @override
  String toString() => taskPrimitive.toString();
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
