import 'dart:async';

import 'package:tasky/core/either.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/failures/failures.dart';
import 'package:tasky/domain/repositories/archive_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit class used to manage the state of the archived tasks page.
class ArchiveBloc extends Cubit<ArchiveState> {
  final ArchiveRepository _repository;
  StreamSubscription<Either<Failure, IList<Task>>>? _archivedSubscription;

  ArchiveBloc({required ArchiveRepository repository})
      : _repository = repository,
        super(ArchiveState.initial());

  /// Tells [ArchiveBloc] to fetch the data from [ArchiveRepository].
  Future<void> fetch({bool showLoading = true}) async {
    if (showLoading) emit(state.copyWith(isLoading: true, hasError: false));

    await _archivedSubscription?.cancel();
    _archivedSubscription =
        _repository.watchArchivedTasks().listen((event) => event.fold(
              (_) => emit(state.copyWith(hasError: true, isLoading: false)),
              (right) => emit(state.copyWith(
                data: right,
                hasError: false,
                isLoading: false,
              )),
            ));
  }

  @override
  Future<void> close() async {
    await _archivedSubscription?.cancel();
    return super.close();
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
  final IList<Task> data;

  @visibleForTesting
  const ArchiveState(this.data, this.hasError, this.isLoading);

  /// Constructor for the initial state.
  factory ArchiveState.initial() => ArchiveState(IList.empty(), false, true);

  /// Returns a copy of [ArchiveState] with some field changed.
  ArchiveState copyWith({
    IList<Task>? data,
    bool? hasError,
    bool? isLoading,
  }) =>
      ArchiveState(
        data ?? this.data,
        hasError ?? this.hasError,
        isLoading ?? this.isLoading,
      );

  @override
  String toString() => "ArchiveState {isLoading: $isLoading, "
      "hasError: $hasError, "
      "data: ${(data.isNotEmpty) ? "[${data.length}]" : data}}";

  @override
  List<Object> get props => [isLoading, hasError, data];
}
