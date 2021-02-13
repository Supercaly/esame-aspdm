import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/repositories/task_repository.dart';
import 'package:tasky/services/link_service.dart';
import 'package:tasky/services/log_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Class used to manage the state of the task info page.
class TaskBloc extends Cubit<TaskState> {
  final TaskRepository _repository;
  final LogService _logService;
  final LinkService _linkService;

  /// Id of the task that we want to display.
  final Maybe<UniqueId> _taskId;

  TaskBloc({
    @required Maybe<UniqueId> taskId,
    @required TaskRepository repository,
    @required LogService logService,
    @required LinkService linkService,
  })  : _taskId = taskId ?? Maybe<UniqueId>.nothing(),
        _repository = repository,
        _logService = logService,
        _linkService = linkService,
        super(TaskState.initial());

  /// Tells [TaskRepository] to fetch the task with id [_taskId].
  Future<void> fetch({bool showLoading = true}) async {
    if (showLoading) emit(state.copyWith(isLoading: true, hasError: false));

    (await _repository.getTask(_taskId)).fold(
      (_) => emit(state.copyWith(isLoading: false, hasError: true)),
      (newTask) => emit(state.copyWith(
        data: newTask,
        isLoading: false,
        hasError: false,
      )),
    );
  }

  /// Tells [TaskRepository] the user wants to delete one of his
  /// comments under this task.
  Future<void> deleteComment(UniqueId commentId, Maybe<UniqueId> userId) async {
    (await _repository.deleteComment(_taskId, commentId, userId)).fold(
      (e) {
        _logService.error("TaskBloc.deleteComment: ", e);
        emit(state.copyWith(isLoading: false, hasError: true));
      },
      (newTask) => emit(state.copyWith(
        data: newTask,
        isLoading: false,
        hasError: false,
      )),
    );
  }

  /// Tells [TaskRepository] the user wants to edit one of his
  /// comments under this task.
  Future<void> editComment(
    UniqueId commentId,
    CommentContent newContent,
    Maybe<UniqueId> userId,
  ) async {
    (await _repository.editComment(_taskId, commentId, newContent, userId))
        .fold(
      (e) {
        _logService.error("TaskBloc.editComment: ", e);
        emit(state.copyWith(isLoading: false, hasError: true));
      },
      (newTask) => emit(state.copyWith(
        data: newTask,
        isLoading: false,
        hasError: false,
      )),
    );
  }

  /// Tells [TaskRepository] the user created a new comment under this task.
  Future<void> addComment(
      CommentContent content, Maybe<UniqueId> userId) async {
    (await _repository.addComment(_taskId, content, userId)).fold(
      (e) {
        _logService.error("TaskBloc.addComment: ", e);
        emit(state.copyWith(isLoading: false, hasError: true));
      },
      (newTask) => emit(state.copyWith(
        data: newTask,
        isLoading: false,
        hasError: false,
      )),
    );
  }

  /// Tells [TaskRepository] the user likes a comment under this task.
  Future<void> likeComment(UniqueId commentId, Maybe<UniqueId> userId) async {
    (await _repository.likeComment(_taskId, commentId, userId)).fold(
      (e) {
        _logService.error("TaskBloc.likeComment: ", e);
        emit(state.copyWith(isLoading: false, hasError: true));
      },
      (newTask) => emit(state.copyWith(
        data: newTask,
        isLoading: false,
        hasError: false,
      )),
    );
  }

  /// Tells [TaskRepository] the user dislikes a comment under this task.
  Future<void> dislikeComment(
      UniqueId commentId, Maybe<UniqueId> userId) async {
    (await _repository.dislikeComment(_taskId, commentId, userId)).fold(
      (e) {
        _logService.error("TaskBloc.dislikeComment: ", e);
        emit(state.copyWith(isLoading: false, hasError: true));
      },
      (newTask) => emit(state.copyWith(
        data: newTask,
        isLoading: false,
        hasError: false,
      )),
    );
  }

  /// Tells [TaskRepository] the task is archived.
  Future<void> archive(Maybe<UniqueId> userId) async {
    (await _repository.archiveTask(_taskId, userId)).fold(
      (e) {
        _logService.error("TaskBloc.archive: ", e);
        emit(state.copyWith(isLoading: false, hasError: true));
      },
      (newTask) => emit(state.copyWith(
        data: newTask,
        isLoading: false,
        hasError: false,
      )),
    );
  }

  /// Tells [TaskRepository] the task is un-archived.
  Future<void> unarchive(Maybe<UniqueId> userId) async {
    (await _repository.unarchiveTask(_taskId, userId)).fold(
      (e) {
        _logService.error("TaskBloc.unarchive: ", e);
        emit(state.copyWith(isLoading: false, hasError: true));
      },
      (newTask) => emit(state.copyWith(
        data: newTask,
        isLoading: false,
        hasError: false,
      )),
    );
  }

  /// Tells [TaskRepository] a checklist's item is completed.
  Future<void> completeChecklist(
    Maybe<UniqueId> userId,
    UniqueId checklistId,
    UniqueId itemId,
    Toggle complete,
  ) async {
    (await _repository.completeChecklist(
      _taskId,
      userId,
      checklistId,
      itemId,
      complete,
    ))
        .fold(
      (e) {
        _logService.error("TaskBlock.completeChecklist: ", e);
        emit(state.copyWith(isLoading: false, hasError: true));
      },
      (newTask) => emit(state.copyWith(
        data: newTask,
        isLoading: false,
        hasError: false,
      )),
    );
  }

  /// Uses the [LinkService] to generate a sharable link.
  Future<void> share() async {
    (await _linkService.createLinkForPost(_taskId)).fold(
      () => emit(state.copyWith(
        shareError: true,
        shareLink: Maybe.nothing(),
        isLoading: false,
      )),
      (link) => emit(state.copyWith(
        shareLink: Maybe.just(link.toString()),
        shareError: false,
        hasError: false,
        isLoading: false,
      )),
    );
  }
}

/// Class with the state of the [TaskBloc].
class TaskState extends Equatable {
  /// Tells the widget that the data is loading.
  final bool isLoading;

  /// Tells the widget that there was an error.
  final bool hasError;

  /// The task to display.
  final Task data;

  /// The generated sharable link.
  final String shareLink;

  /// Tells the widget that there was an error sharing.
  final bool shareError;

  @visibleForTesting
  const TaskState(
    this.data,
    this.hasError,
    this.isLoading,
    this.shareError,
    this.shareLink,
  );

  /// Constructor for the initial state.
  factory TaskState.initial() => TaskState(null, false, true, false, null);

  /// Returns a copy of [TaskState] with some field changed.
  TaskState copyWith({
    Task data,
    bool isLoading,
    bool hasError,
    bool shareError,
    Maybe<String> shareLink,
  }) =>
      TaskState(
        data ?? this.data,
        hasError ?? this.hasError,
        isLoading ?? this.isLoading,
        shareError ?? this.shareError,
        shareLink?.getOrNull() ?? this.shareLink,
      );

  @override
  String toString() => "TaskState{isLoading: $isLoading, "
      "hasError: $hasError, "
      "data: $data, "
      "shareLink: $shareLink, "
      "shareError: $shareError}";

  @override
  List<Object> get props => [isLoading, hasError, data, shareLink, shareError];
}
