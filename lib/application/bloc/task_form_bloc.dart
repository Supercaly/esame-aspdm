import 'package:aspdm_project/domain/entities/checklist.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskFormBloc extends Cubit<TaskFormState> {
  // TODO: Introduce a TaskPrimitive instead of straight Task
  TaskFormBloc(Task oldTask)
      : super(TaskFormState.initial(oldTask ?? Task.empty()));

  void titleChanged(String value) {
    print("EditTaskBloc.titleChanged: $value");
    emit(state.copyWith(task: state.task.copyWith(title: TaskTitle(value))));
  }

  void descriptionChanged(String value) {
    print("EditTaskBloc.descriptionChanged: $value");
    emit(state.copyWith(
      task: state.task.copyWith(description: TaskDescription(value)),
    ));
  }

  void dateChanged(DateTime value) {
    print("TaskFormBloc.dateChanged: $value");
    print(state.task.expireDate);
    print(state.task.copyWith(expireDate: value).expireDate);
    emit(state.copyWith(task: state.task.copyWith(expireDate: value)));
  }

  void membersChanged(List<User> value) {
    print("TaskFormBloc.membersChanged: $value");
    emit(state.copyWith(task: state.task.copyWith(members: value)));
  }

  void labelsChanged(List<Label> value) {
    print("TaskFormBloc.labelsChanged: $value");
    emit(state.copyWith(task: state.task.copyWith(labels: value)));
  }

  int idx = 0;
  void addChecklist() {
    print("TaskFormBloc.addChecklist: ${state.task.checklists}");
    emit(
      state.copyWith(
        task: state.task.copyWith(
          checklists: state.task.checklists.addImmutable(
            Checklist(UniqueId("INVALID_ID"), ItemText("Checklist ${++idx}"), [
              ChecklistItem(
                UniqueId("INVALID_ID"),
                ItemText("item"),
                Toggle(false),
              ),
              ChecklistItem(
                UniqueId("INVALID_ID"),
                ItemText("item"),
                Toggle(false),
              ),
              ChecklistItem(
                UniqueId("INVALID_ID"),
                ItemText("item"),
                Toggle(false),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void removeChecklist(Checklist value) {
    print("TaskFormBloc.removeChecklist: $value");
    emit(
      state.copyWith(
        task: state.task.copyWith(
          checklists: state.task.checklists.removeImmutable(value),
        ),
      ),
    );
  }

  Future<void> saveTask() async {
    print("EditTaskBloc.saveTask: Saving task...");
    print("EditTaskBloc.saveTask: ${state.task}");
    emit(state.copyWith(isSaving: true));
    await Future.delayed(Duration(seconds: 5));
    emit(state.copyWith(isSaving: false));
  }
}

class TaskFormState extends Equatable {
  final Task task;
  final bool isSaving;

  TaskFormState._(this.task, this.isSaving);

  factory TaskFormState.initial(Task task) => TaskFormState._(task, false);

  TaskFormState copyWith({Task task, bool isSaving}) =>
      TaskFormState._(task ?? this.task, isSaving ?? this.isSaving);

  @override
  List<Object> get props => [task, isSaving];

  @override
  String toString() => task.toString();
}

// TODO: Optimize all this list shenanigans.
extension ListX<E> on List<E> {
  List<E> addImmutable(E element) {
    if (this.isEmpty) return List.of([element]);
    List<E> result = List<E>();
    result.addAll(this);
    result.add(element);
    return result;
  }

  List<E> removeImmutable(E element) {
    if (this.isEmpty) return List.empty();
    List<E> result = List<E>();
    result.addAll(this);
    result.remove(element);
    return result;
  }
}
