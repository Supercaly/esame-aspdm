import 'package:aspdm_project/domain/entities/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspdm_project/domain/repositories/members_repository.dart';

/// Class used to manage the state of the tasks page.
class MembersBloc extends Cubit<MembersState> {
  MembersRepository _repository;

  MembersBloc(this._repository) : super(MembersState.initial());

  Future<void> fetch() async {
    emit(state.copyWith(isLoading: true, hasError: false));
    (await _repository.getUsers()).fold(
      (left) => emit(state.copyWith(isLoading: false, hasError: true)),
      (right) => emit(state.copyWith(
        members: right,
        isLoading: false,
        hasError: false,
      )),
    );
  }
}

/// Class with the state of the [MembersBloc].
class MembersState extends Equatable {
  final List<User> members;
  final bool isLoading;
  final bool hasError;

  @visibleForTesting
  MembersState(this.members, this.isLoading, this.hasError);

  /// Constructor for the initial state.
  factory MembersState.initial() => MembersState([], true, false);

  /// Returns a copy of [MembersState] with some field changed.
  MembersState copyWith({
    List<User> members,
    bool hasError,
    bool isLoading,
  }) =>
      MembersState(
        members ?? this.members,
        isLoading ?? this.isLoading,
        hasError ?? this.hasError,
      );

  @override
  List<Object> get props => [members, isLoading];

  @override
  String toString() => "MembersState{members: $members, "
      "isLoading: $isLoading, "
      "hasError: $hasError}";
}
