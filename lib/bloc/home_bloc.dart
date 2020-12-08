import 'package:aspdm_project/model/task.dart';
import 'package:aspdm_project/repositories/home_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Class used to manage the state of the tasks page.
class HomeBloc extends Cubit<HomeState> {
  final HomeRepository _repository;

  /// Keep in memory the old data so they can be
  /// displayed even during loading or error.
  List<Task> _oldData = [];

  HomeBloc(this._repository) : super(HomeState.loading([]));

  /// Tells [HomeBloc] to fetch new data from [HomeRepository].
  Future<void> fetch({bool showLoading = true}) async {
    if (showLoading) emit(HomeState.loading(_oldData));
    try {
      final newData = await _repository.getTasks();
      if (newData != null)
        _oldData = newData;
      else
        _oldData = [];
      emit(HomeState.data(newData));
    } catch (e) {
      emit(HomeState.error(_oldData));
    }
  }
}

/// Class with the state of the [HomeBloc].
class HomeState extends Equatable {
  /// Tells the widget that the data is loading.
  final bool isLoading;

  /// Tells the widget that there was an error.
  final bool hasError;

  /// List of tasks to display.
  final List<Task> data;

  /// Constructor for the data.
  const HomeState.data(this.data)
      : isLoading = false,
        hasError = false;

  /// Constructor for loading.
  const HomeState.loading(this.data)
      : isLoading = true,
        hasError = false;

  /// Constructor for error.
  const HomeState.error(this.data)
      : isLoading = false,
        hasError = true;

  @override
  String toString() => "HomeState {isLoading: $isLoading, "
      "hasError: $hasError, "
      "data: ${(data.isNotEmpty) ? "[${data.length}]" : data}}";

  @override
  List<Object> get props => [isLoading, hasError, data];
}
