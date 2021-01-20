import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LabelsBloc extends Cubit<LabelsState> {
  LabelsBloc() : super(LabelsState.loading());

  Future<void> fetch() async {
    emit(LabelsState.loading());
    await Future.delayed(Duration(seconds: 2));
    emit(LabelsState.data([
      Label(UniqueId("label1"), Colors.green, "label1"),
      Label(UniqueId("label2"), Colors.yellow, "label2"),
      Label(UniqueId("label3"), Colors.red, "label3"),
      Label(UniqueId("label4"), Colors.blue, "label4"),
      Label(UniqueId("label5"), Colors.deepOrange, "label5"),
      Label(UniqueId("label6"), Colors.cyan, "label6"),
      Label(UniqueId("label6"), Colors.cyan, "label6"),
      Label(UniqueId("label6"), Colors.cyan, "label6"),
      Label(UniqueId("label6"), Colors.cyan, "label6"),
      Label(UniqueId("label6"), Colors.cyan, "label6"),
      Label(UniqueId("label6"), Colors.cyan, "label6"),
      Label(UniqueId("label6"), Colors.cyan, "label6"),
      Label(UniqueId("label6"), Colors.cyan, "label6"),
      Label(UniqueId("label6"), Colors.cyan, "label6"),
      Label(UniqueId("label6"), Colors.cyan, "label6"),
      Label(UniqueId("label6"), Colors.cyan, "label6"),
    ]));
  }
}

class LabelsState extends Equatable {
  final List<Label> labels;
  final bool isLoading;

  LabelsState._(this.labels, this.isLoading);

  factory LabelsState.loading() => LabelsState._([], true);
  factory LabelsState.data(List<Label> data) => LabelsState._(data, false);

  @override
  List<Object> get props => [labels, isLoading];
}
