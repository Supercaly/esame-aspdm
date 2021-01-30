import 'package:aspdm_project/core/ilist.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/repositories/label_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Class used to manage the state of the label dialog.
class LabelsBloc extends Cubit<LabelsState> {
  LabelRepository repository;

  LabelsBloc({IList<Label> initialValue, this.repository})
      : super(LabelsState.initial(initialValue));

  Future<void> fetch() async {
    emit(state.copyWith(isLoading: true, hasError: false));
    (await repository.getLabels()).fold(
      (left) => emit(state.copyWith(isLoading: false, hasError: true)),
      (right) => emit(state.copyWith(
        labels: right,
        hasError: false,
        isLoading: false,
      )),
    );
  }

  void selectLabel(Label value) {
    emit(state.copyWith(
      selected: state.selected.append(value),
      isLoading: false,
      hasError: false,
    ));
  }

  void deselectLabel(Label value) {
    emit(state.copyWith(
      selected: state.selected.remove(value),
      isLoading: false,
      hasError: false,
    ));
  }
}

/// Class with the state of the [LabelsBloc].
class LabelsState extends Equatable {
  final IList<Label> selected;
  final IList<Label> labels;
  final bool isLoading;
  final bool hasError;

  @visibleForTesting
  LabelsState(this.selected, this.labels, this.isLoading, this.hasError);

  /// Constructor for the initial state.
  factory LabelsState.initial(IList<Label> oldLabels) => LabelsState(
        oldLabels ?? IList.empty(),
        IList.empty(),
        true,
        false,
      );

  /// Returns a copy of [LabelsState] with some field changed.
  LabelsState copyWith({
    IList<Label> selected,
    IList<Label> labels,
    bool hasError,
    bool isLoading,
  }) =>
      LabelsState(
        selected ?? this.selected,
        labels ?? this.labels,
        isLoading ?? this.isLoading,
        hasError ?? this.hasError,
      );

  @override
  List<Object> get props => [selected, labels, isLoading, hasError];

  @override
  String toString() => "LabelsState{selected: $selected, labels: $labels, "
      "isLoading: $isLoading, "
      "hasError: $hasError}";
}
