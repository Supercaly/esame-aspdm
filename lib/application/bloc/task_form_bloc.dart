import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/presentation/misc/checklist_primitive.dart';
import 'package:aspdm_project/presentation/misc/task_primitive.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskFormBloc extends Cubit<TaskFormState> {
  TaskFormBloc(Task oldTask)
      : super(TaskFormState.initial((oldTask != null)
            ? TaskPrimitive.fromTask(oldTask)
            : TaskPrimitive.empty()));

  void titleChanged(String value) {
    print("EditTaskBloc.titleChanged: $value");
    emit(
      state.copyWith(
        taskPrimitive: state.taskPrimitive.copyWith(
          title: TaskTitle(value),
        ),
      ),
    );
  }

  void descriptionChanged(String value) {
    print("EditTaskBloc.descriptionChanged: $value");
    emit(state.copyWith(
      taskPrimitive: state.taskPrimitive.copyWith(
        description: TaskDescription(value),
      ),
    ));
  }

  void dateChanged(DateTime value) {
    print("TaskFormBloc.dateChanged: $value");
    print(state.taskPrimitive.expireDate);
    print(state.taskPrimitive.copyWith(expireDate: value).expireDate);
    emit(
      state.copyWith(
        taskPrimitive: state.taskPrimitive.copyWith(expireDate: value),
      ),
    );
  }

  void membersChanged(List<User> value) {
    print("TaskFormBloc.membersChanged: $value");
    emit(state.copyWith(
        taskPrimitive: state.taskPrimitive.copyWith(members: value)));
  }

  void labelsChanged(List<Label> value) {
    print("TaskFormBloc.labelsChanged: $value");
    emit(state.copyWith(
        taskPrimitive: state.taskPrimitive.copyWith(labels: value)));
  }

  void addChecklist(ChecklistPrimitive value) {
    print("TaskFormBloc.addChecklist: $value");
    emit(
      state.copyWith(
        taskPrimitive: state.taskPrimitive.copyWith(
          checklists: state.taskPrimitive.checklists.addImmutable(value),
        ),
      ),
    );
  }

  void removeChecklist(ChecklistPrimitive value) {
    print("TaskFormBloc.removeChecklist: $value");
    emit(
      state.copyWith(
        taskPrimitive: state.taskPrimitive.copyWith(
          checklists: state.taskPrimitive.checklists.removeImmutable(value),
        ),
      ),
    );
  }

  Future<void> saveTask() async {
    print("EditTaskBloc.saveTask: Saving task...");
    print("EditTaskBloc.saveTask: ${state.taskPrimitive}");
    emit(state.copyWith(isSaving: true));
    await Future.delayed(Duration(seconds: 5));
    emit(state.copyWith(isSaving: false));
  }
}

class TaskFormState extends Equatable {
  final TaskPrimitive taskPrimitive;
  final bool isSaving;
  final bool isInitial;

  TaskFormState._(this.taskPrimitive, this.isSaving, this.isInitial);

  factory TaskFormState.initial(TaskPrimitive primitive) =>
      TaskFormState._(primitive, false, true);

  TaskFormState copyWith({TaskPrimitive taskPrimitive, bool isSaving}) =>
      TaskFormState._(
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
}
