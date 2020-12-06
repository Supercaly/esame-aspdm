import 'package:aspdm_project/model/task.dart';
import 'package:aspdm_project/repositories/archive_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit class used to manage the state of the archived tasks page.
class ArchiveBloc extends Cubit<ArchiveState> {
  ArchiveRepository _repository;

  /// Keep in memory the old data so they can be
  /// displayed even during loading or error.
  List<Task> _oldTasks = [];

  ArchiveBloc(this._repository) : super(const ArchiveState.loading([]));

  /// Tells [ArchiveBloc] to fetch the data from [ArchiveRepository].
  Future<void> fetch({bool showLoading = true}) async {
    if (showLoading) emit(ArchiveState.loading(_oldTasks));
    try {
      final newTasks = await _repository.getArchivedTasks();
      _oldTasks = newTasks;
      emit(ArchiveState.data(newTasks));
    } catch (e) {
      emit(ArchiveState.error(_oldTasks));
    }
  }
}

/// Class with the state of the [ArchiveBloc].
class ArchiveState {
  /// Tells the widget that the data is loading.
  final bool isLoading;

  /// Tells the widget that there was an error
  /// retrieving the data.
  final bool hasError;

  /// List of archived tasks.
  final List<Task> data;

  /// Creates a new [ArchiveState] ensuring that [data], [isLoading]
  /// and [hasError] will never be `null`.
  const ArchiveState(this.isLoading, this.hasError, this.data)
      : assert(data != null),
        assert(isLoading != null),
        assert(hasError != null);

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
}
