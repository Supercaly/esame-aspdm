import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/repositories/label_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Class used to manage the state of the label dialog.
class LabelsBloc extends Cubit<LabelsState> {
  LabelRepository _repository;

  LabelsBloc(this._repository) : super(LabelsState.initial());

  Future<void> fetch() async {
    emit(state.copyWith(isLoading: true, hasError: false));
    (await _repository.getLabels()).fold(
      (left) => emit(state.copyWith(isLoading: false, hasError: true)),
      (right) => emit(state.copyWith(
        labels: right,
        hasError: false,
        isLoading: false,
      )),
    );
  }
}

/// Class with the state of the [LabelsBloc].
class LabelsState extends Equatable {
  final List<Label> labels;
  final bool isLoading;
  final bool hasError;

  @visibleForTesting
  LabelsState(this.labels, this.isLoading, this.hasError);

  /// Constructor for the initial state.
  factory LabelsState.initial() => LabelsState([], true, false);

  /// Returns a copy of [LabelsState] with some field changed.
  LabelsState copyWith({
    List<Label> labels,
    bool hasError,
    bool isLoading,
  }) =>
      LabelsState(
        labels ?? this.labels,
        isLoading ?? this.isLoading,
        hasError ?? this.hasError,
      );

  @override
  List<Object> get props => [labels, isLoading];

  @override
  String toString() => "LabelsState{labels: $labels, "
      "isLoading: $isLoading, "
      "hasError: $hasError}";
}
