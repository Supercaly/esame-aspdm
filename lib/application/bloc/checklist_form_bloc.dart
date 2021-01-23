import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/presentation/misc/checklist_primitive.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspdm_project/application/bloc/task_form_bloc.dart';

/// Cubit class used to manage the state of the checklist form page and dialog.
class ChecklistFormBloc extends Cubit<ChecklistFormState> {
  ChecklistFormBloc({ChecklistPrimitive initialValue})
      : super(ChecklistFormState.initial(initialValue));

  /// Called when the title of the checklist changes.
  void titleChanged(String value) {
    emit(state.copyWith(title: ItemText(value)));
  }

  /// Called when a new checklist's item is added.
  void addItem(ItemText value) {
    emit(state.copyWith(items: state.items.addImmutable(value)));
  }

  /// Called when a new checklist's item is removed.
  void removeItem(int index) {
    emit(state.copyWith(items: state.items.removeAtImmutable(index)));
  }

  /// Called when a new checklist's item is edited.
  void editItem(int index, ItemText value) {
    emit(state.copyWith(items: state.items.updatedImmutable(index, value)));
  }

  /// Called when the user wants to save the changes to the checklist.
  void save() {
    emit(state.copyWith(isSave: true));
  }
}

/// Class representing the state passed by a [ChecklistFormBloc].
class ChecklistFormState extends Equatable {
  final ItemText title;
  final List<ItemText> items;
  final bool isSave;
  
  @visibleForTesting
  ChecklistFormState(this.title, this.items, this.isSave);

  factory ChecklistFormState.initial(ChecklistPrimitive value) =>
      ChecklistFormState(
        value?.title ?? ItemText("Checklist"),
        value?.items ?? [],
        false,
      );

  ChecklistFormState copyWith(
          {ItemText title, List<ItemText> items, bool isSave}) =>
      ChecklistFormState(
        title ?? this.title,
        items ?? this.items,
        isSave ?? this.isSave,
      );

  @override
  List<Object> get props => [title, items, isSave];

  @override
  String toString() =>
      "ChecklistFormState{title: $title, items: $items, isSave: $isSave}";
}
