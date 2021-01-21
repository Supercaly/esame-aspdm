import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/repositories/label_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LabelsBloc extends Cubit<LabelsState> {
  LabelRepository _repository;

  LabelsBloc(this._repository) : super(LabelsState.loading());

  Future<void> fetch() async {
    emit(LabelsState.loading());
    (await _repository.getLabels()).fold(
      (left) => emit(LabelsState.error()),
      (right) => emit(
        LabelsState.data(right),
      ),
    );
  }
}

class LabelsState extends Equatable {
  final List<Label> labels;
  final bool isLoading;
  final bool hasError;

  LabelsState._(this.labels, this.isLoading, this.hasError);

  factory LabelsState.loading() => LabelsState._([], true, false);
  factory LabelsState.error() => LabelsState._([], false, true);
  factory LabelsState.data(List<Label> data) =>
      LabelsState._(data, false, false);

  @override
  List<Object> get props => [labels, isLoading];
}
