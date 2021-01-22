import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/presentation/misc/checklist_primitive.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspdm_project/application/bloc/task_form_bloc.dart';

class ChecklistFormBloc extends Cubit<ChecklistFormState> {
  ChecklistFormBloc() : super(ChecklistFormState.initial());

  void titleChanged(String value) {
    emit(state.copyWith(title: value));
  }

  void addItem(ItemText value) {
    emit(state.copyWith(items: state.items.addImmutable(value)));
  }

  void removeItem(int index) {
    emit(state.copyWith(items: state.items.removeAtImmutable(index)));
  }

  void editItem(int index, ItemText value) {
    emit(state.copyWith(items: state.items.updatedImmutable(index, value)));
  }

  void save() {
    emit(ChecklistFormState.save(
      ChecklistPrimitive(
        title: ItemText(state.title),
        items: state.items,
      ),
    ));
  }
}

class ChecklistFormState extends Equatable {
  final String title;
  final List<ItemText> items;
  final bool isSave;

  ChecklistPrimitive get primitive => ChecklistPrimitive(
        title: ItemText(title),
        items: items,
      );

  ChecklistFormState._(this.title, this.items, this.isSave);
  factory ChecklistFormState.initial() => ChecklistFormState._(
        "Checklist",
        [],
        false,
      );
  factory ChecklistFormState.save(ChecklistPrimitive primitive) =>
      ChecklistFormState._(
        null,
        null,
        true,
      );

  ChecklistFormState copyWith({String title, List<ItemText> items}) =>
      ChecklistFormState._(
        title ?? this.title,
        items ?? this.items,
        false,
      );

  @override
  List<Object> get props => [title, items];
}
