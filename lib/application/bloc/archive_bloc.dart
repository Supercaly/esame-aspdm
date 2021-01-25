import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/repositories/archive_repository.dart';
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
    (await _repository.getArchivedTasks()).fold(
      (_) {
        emit(ArchiveState.error(_oldData));
      },
      (right) {
        _oldData = right;
        emit(ArchiveState.data(_oldData));
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

  // TODO(#53) Refactor to use copyWith pattern
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
