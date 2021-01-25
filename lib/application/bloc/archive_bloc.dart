import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/repositories/archive_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit class used to manage the state of the archived tasks page.
class ArchiveBloc extends Cubit<ArchiveState> {
  final ArchiveRepository _repository;

  ArchiveBloc(this._repository) : super(ArchiveState.initial());

  /// Tells [ArchiveBloc] to fetch the data from [ArchiveRepository].
  Future<void> fetch({bool showLoading = true}) async {
    if (showLoading) emit(state.copyWith(isLoading: true, hasError: false));
    (await _repository.getArchivedTasks()).fold(
      (_) {
        emit(state.copyWith(hasError: true, isLoading: false));
      },
      (right) {
        emit(state.copyWith(data: right, hasError: false, isLoading: false));
      },
    );
  }
}

/// Class with the state of the [ArchiveBloc].
class ArchiveState extends Equatable {
  /// Tells the widget that the data is loading.
  final bool isLoading;

  /// Tells the widget that there was an error
  /// retrieving the data.
  final bool hasError;

  /// List of archived tasks.
  final List<Task> data;

  @visibleForTesting
  const ArchiveState(this.data, this.hasError, this.isLoading);

  /// Constructor for the initial state.
  factory ArchiveState.initial() => ArchiveState([], false, true);

  // TODO(#53) Refactor to use copyWith pattern
  /// Returns a copy of [ArchiveState] with some field changed.
  ArchiveState copyWith({
    List<Task> data,
    bool hasError,
    bool isLoading,
  }) =>
      ArchiveState(
        data ?? this.data,
        hasError ?? this.hasError,
        isLoading ?? this.isLoading,
      );

  @override
  String toString() => "HomeState {isLoading: $isLoading, "
      "hasError: $hasError, "
      "data: ${(data.isNotEmpty) ? "[${data.length}]" : data}}";

  @override
  List<Object> get props => [isLoading, hasError, data];
}
