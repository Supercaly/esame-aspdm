import 'package:aspdm_project/domain/entities/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspdm_project/domain/repositories/members_repository.dart';

class MembersBloc extends Cubit<MembersState> {
  MembersRepository _repository;

  MembersBloc(this._repository) : super(MembersState.loading());

  Future<void> fetch() async {
    emit(MembersState.loading());
    (await _repository.getUsers()).fold(
      (left) => emit(MembersState.error()),
      (right) => emit(
        MembersState.data(right),
      ),
    );
  }
}

class MembersState extends Equatable {
  final List<User> members;
  final bool isLoading;
  final bool hasError;

  MembersState._(this.members, this.isLoading, this.hasError);

  factory MembersState.loading() => MembersState._([], true, false);
  factory MembersState.error() => MembersState._([], false, true);
  factory MembersState.data(List<User> data) =>
      MembersState._(data, false, false);

  @override
  List<Object> get props => [members, isLoading];
}
