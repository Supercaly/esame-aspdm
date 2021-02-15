import 'dart:async';

import 'package:tasky/core/either.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/failures/failures.dart';
import 'package:tasky/domain/repositories/home_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Class used to manage the state of the tasks page.
class HomeBloc extends Cubit<HomeState> {
  final HomeRepository _repository;
  StreamSubscription<Either<Failure, IList<Task>>> _tasksSubscription;

  HomeBloc({@required HomeRepository repository})
      : _repository = repository,
        super(HomeState.initial());

  /// Tells [HomeBloc] to fetch new data from [HomeRepository].
  Future<void> fetch({bool showLoading = true}) async {
    if (showLoading) emit(state.copyWith(isLoading: true, hasError: false));

    await _tasksSubscription?.cancel();
    _tasksSubscription = _repository.watchTasks().listen((event) => event.fold(
          (_) => emit(state.copyWith(isLoading: false, hasError: true)),
          (right) => emit(state.copyWith(
            data: right,
            hasError: false,
            isLoading: false,
          )),
        ));
  }

  @override
  Future<void> close() async {
    await _tasksSubscription?.cancel();
    return super.close();
  }
}

/// Class with the state of the [HomeBloc].
class HomeState extends Equatable {
  /// Tells the widget that the data is loading.
  final bool isLoading;

  /// Tells the widget that there was an error.
  final bool hasError;

  /// List of tasks to display.
  final IList<Task> data;

  @visibleForTesting
  const HomeState(this.data, this.hasError, this.isLoading);

  /// Constructor for the initial state.
  factory HomeState.initial() => HomeState(IList.empty(), false, true);

  /// Returns a copy of [HomeState] with some field changed.
  HomeState copyWith({
    IList<Task> data,
    bool hasError,
    bool isLoading,
  }) =>
      HomeState(
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
