import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/domain/repositories/members_repository.dart';

/// Class used to manage the state of the tasks page.
class MembersBloc extends Cubit<MembersState> {
  MembersRepository repository;

  MembersBloc({IList<User> initialValue, this.repository})
      : super(MembersState.initial(initialValue));

  Future<void> fetch() async {
    emit(state.copyWith(isLoading: true, hasError: false));
    (await repository.getUsers()).fold(
      (left) => emit(state.copyWith(isLoading: false, hasError: true)),
      (right) => emit(state.copyWith(
        members: right,
        isLoading: false,
        hasError: false,
      )),
    );
  }

  void selectMember(User value) {
    emit(state.copyWith(
      selected: state.selected.append(value),
      isLoading: false,
      hasError: false,
    ));
  }

  void deselectMember(User value) {
    emit(state.copyWith(
      selected: state.selected.remove(value),
      isLoading: false,
      hasError: false,
    ));
  }
}

/// Class with the state of the [MembersBloc].
class MembersState extends Equatable {
  final IList<User> selected;
  final IList<User> members;
  final bool isLoading;
  final bool hasError;

  @visibleForTesting
  MembersState(this.selected, this.members, this.isLoading, this.hasError);

  /// Constructor for the initial state.
  factory MembersState.initial(IList<User> oldMembers) =>
      MembersState(oldMembers ?? IList.empty(), IList.empty(), true, false);

  /// Returns a copy of [MembersState] with some field changed.
  MembersState copyWith({
    IList<User> selected,
    IList<User> members,
    bool hasError,
    bool isLoading,
  }) =>
      MembersState(
        selected ?? this.selected,
        members ?? this.members,
        isLoading ?? this.isLoading,
        hasError ?? this.hasError,
      );

  @override
  List<Object> get props => [selected, members, isLoading, hasError];

  @override
  String toString() => "MembersState{selected: $selected, members: $members, "
      "isLoading: $isLoading, "
      "hasError: $hasError}";
}
