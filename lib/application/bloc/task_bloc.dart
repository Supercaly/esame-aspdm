import 'package:aspdm_project/core/maybe.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/repositories/task_repository.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Class used to manage the state of the task info page.
class TaskBloc extends Cubit<TaskState> {
  final TaskRepository repository;
  final LogService logService;

  /// Id of the task that we want to display.
  final Maybe<UniqueId> taskId;

  TaskBloc({
    this.taskId,
    this.repository,
    this.logService,
  }) : super(TaskState.initial());

  /// Tells [TaskRepository] to fetch the task with id [taskId].
  Future<void> fetch({bool showLoading = true}) async {
    if (showLoading) emit(state.copyWith(isLoading: true, hasError: false));

    (await repository.getTask(taskId)).fold(
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
    (await repository.deleteComment(taskId, commentId, userId)).fold(
      (e) {
        logService.error("TaskBloc.deleteComment: ", e);
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
    (await repository.editComment(taskId, commentId, newContent, userId)).fold(
      (e) {
        logService.error("TaskBloc.editComment: ", e);
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
    (await repository.addComment(taskId, content, userId)).fold(
      (e) {
        logService.error("TaskBloc.addComment: ", e);
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
    (await repository.likeComment(taskId, commentId, userId)).fold(
      (e) {
        logService.error("TaskBloc.likeComment: ", e);
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
    (await repository.dislikeComment(taskId, commentId, userId)).fold(
      (e) {
        logService.error("TaskBloc.dislikeComment: ", e);
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
    (await repository.archiveTask(taskId, userId)).fold(
      (e) {
        logService.error("TaskBloc.archive: ", e);
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
    (await repository.unarchiveTask(taskId, userId)).fold(
      (e) {
        logService.error("TaskBloc.unarchive: ", e);
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
    (await repository.completeChecklist(
      taskId,
      userId,
      checklistId,
      itemId,
      complete,
    ))
        .fold(
      (e) {
        logService.error("TaskBlock.completeChecklist: ", e);
        emit(state.copyWith(isLoading: false, hasError: true));
      },
      (newTask) => emit(state.copyWith(
        data: newTask,
        isLoading: false,
        hasError: false,
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

  @visibleForTesting
  const TaskState(this.data, this.hasError, this.isLoading);

  /// Constructor for the initial state.
  factory TaskState.initial() => TaskState(null, false, true);

  /// Returns a copy of [TaskState] with some field changed.
  TaskState copyWith({
    Task data,
    bool isLoading,
    bool hasError,
  }) =>
      TaskState(
        data ?? this.data,
        hasError ?? this.hasError,
        isLoading ?? this.isLoading,
      );

  @override
  String toString() => "TaskState {isLoading: $isLoading, "
      "hasError: $hasError, "
      "data: $data}";

  @override
  List<Object> get props => [isLoading, hasError, data];
}
