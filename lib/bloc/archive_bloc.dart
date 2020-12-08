import 'package:aspdm_project/model/task.dart';
import 'package:aspdm_project/repositories/archive_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit class used to manage the state of the archived tasks page.
class ArchiveBloc extends Cubit<ArchiveState> {
  final ArchiveRepository _repository;

  /// Keep in memory the old data so they can be
  /// displayed even during loading or error.
  List<Task> _oldData = [];

  ArchiveBloc(this._repository) : super(const ArchiveState.loading([]));

  /// Tells [ArchiveBloc] to fetch the data from [ArchiveRepository].
  Future<void> fetch({bool showLoading = true}) async {
    if (showLoading) emit(ArchiveState.loading(_oldData));
    try {
      final newData = await _repository.getArchivedTasks();
      if (newData != null)
        _oldData = newData;
      else
        _oldData = [];
      emit(ArchiveState.data(newData));
    } catch (e) {
      emit(ArchiveState.error(_oldData));
    }
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

  /// Constructor for the data.
  const ArchiveState.data(this.data)
      : isLoading = false,
        hasError = false;

  /// Constructor for loading.
  const ArchiveState.loading(this.data)
      : isLoading = true,
        hasError = false;

  /// Constructor for an error.
  const ArchiveState.error(this.data)
      : isLoading = false,
        hasError = true;

  @override
  String toString() => "HomeState {isLoading: $isLoading, "
      "hasError: $hasError, "
      "data: ${(data.isNotEmpty) ? "[${data.length}]" : data}}";

  @override
  List<Object> get props => [isLoading, hasError, data];
}
