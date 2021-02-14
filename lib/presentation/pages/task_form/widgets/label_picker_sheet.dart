import 'package:tasky/application/bloc/labels_bloc.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/label.dart';
import 'package:tasky/domain/repositories/label_repository.dart';
import 'package:tasky/presentation/pages/task_form/widgets/label_picker_item_widget.dart';
import 'package:tasky/presentation/pages/task_form/widgets/sheet_notch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/services/navigation_service.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../locator.dart';

/// Display a bottom sheet that picks the labels.
/// Passing an existing [List] of [labels] to mark them as already selected.
/// Returns a [List] of all the selected [Label]s.
Future<IList<Label>> showLabelPickerSheet(
  BuildContext context,
  IList<Label> labels,
) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => LabelPickerSheet(labels: labels),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
  );
}

/// Widget that display a bottom sheet that picks labels
class LabelPickerSheet extends StatelessWidget {
  final IList<Label> labels;

  LabelPickerSheet({Key key, this.labels}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 24.0,
        bottom: 0.0,
        right: 24.0,
      ),
      child: BlocProvider<LabelsBloc>(
        create: (context) => LabelsBloc(
          initialValue: labels,
          repository: locator<LabelRepository>(),
        )..fetch(),
        child: BlocBuilder<LabelsBloc, LabelsState>(
          builder: (context, state) {
            Widget contentWidget;

            if (state.isLoading)
              contentWidget = Center(child: CircularProgressIndicator());
            else if (state.hasError)
              contentWidget =
                  Center(child: Text('no_label_to_display_msg').tr());
            else
              contentWidget = CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate.fixed(
                      state.labels
                          .map(
                            (e) => LabelPickerItemWidget(
                              label: e,
                              selected: state.selected.contains(e),
                              onSelected: (selected) {
                                if (selected)
                                  context.read<LabelsBloc>().selectLabel(e);
                                else
                                  context.read<LabelsBloc>().deselectLabel(e);
                              },
                            ),
                          )
                          .asList(),
                    ),
                  ),
                ],
              );

            return Column(
              children: [
                SheetNotch(),
                SizedBox(height: 8.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'select_labels_title',
                      style: Theme.of(context).textTheme.headline6,
                    ).tr(),
                    TextButton(
                      onPressed: () {
                        locator<NavigationService>().pop(
                          result: state.selected,
                        );
                      },
                      child: Text('save_btn').tr(),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Expanded(child: contentWidget),
              ],
            );
          },
        ),
      ),
    );
  }
}
