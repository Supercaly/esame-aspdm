// @dart=2.9
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/presentation/misc/checklist_primitive.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit class used to manage the state of the checklist form page and dialog.
class ChecklistFormBloc extends Cubit<ChecklistFormState> {
  ChecklistFormBloc({ChecklistPrimitive initialValue})
      : super(ChecklistFormState.initial(initialValue));

  /// Called when the title of the checklist changes.
  void titleChanged(String value) {
    emit(state.copyWith(primitive: state.primitive.copyWith(title: value)));
  }

  /// Called when a new checklist's item is added.
  void addItem(ItemText value) {
    emit(
      state.copyWith(
        primitive: state.primitive.copyWith(
          items: state.primitive.items.append(value),
        ),
      ),
    );
  }

  /// Called when a new checklist's item is removed.
  void removeItem(ItemText value) {
    emit(
      state.copyWith(
        primitive: state.primitive.copyWith(
          items: state.primitive.items.remove(value),
        ),
      ),
    );
  }

  /// Called when a new checklist's item is edited.
  void editItem(ItemText old, ItemText value) {
    emit(
      state.copyWith(
        primitive: state.primitive.copyWith(
          items: state.primitive.items.patch(old, value),
        ),
      ),
    );
  }

  /// Called when the user wants to save the changes to the checklist.
  void save() {
    emit(state.copyWith(isSave: true));
  }
}

/// Class representing the state passed by a [ChecklistFormBloc].
class ChecklistFormState extends Equatable {
  final ChecklistPrimitive primitive;
  final bool isSave;

  @visibleForTesting
  ChecklistFormState(this.primitive, this.isSave);

  /// Constructor for the initial state.
  factory ChecklistFormState.initial(ChecklistPrimitive value) =>
      ChecklistFormState(
        value ?? ChecklistPrimitive(title: "Checklist", items: IList.empty()),
        false,
      );

  /// Returns a copy of [MembersState] with some field changed.
  ChecklistFormState copyWith({
    ChecklistPrimitive primitive,
    bool isSave,
  }) =>
      ChecklistFormState(
        primitive ?? this.primitive,
        isSave ?? this.isSave,
      );

  @override
  List<Object> get props => [primitive, isSave];

  @override
  String toString() =>
      "ChecklistFormState{primitive: $primitive, isSave: $isSave}";
}
