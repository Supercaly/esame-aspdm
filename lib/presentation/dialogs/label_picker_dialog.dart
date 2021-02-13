import 'package:tasky/application/bloc/labels_bloc.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/label.dart';
import 'package:tasky/domain/repositories/label_repository.dart';
import 'package:tasky/locator.dart';
import 'package:tasky/presentation/widgets/label_picker_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/services/navigation_service.dart';
import 'package:easy_localization/easy_localization.dart';

/// Display a dialog that picks the labels.
/// Passing an existing [List] of [labels] to mark them as already selected.
/// Returns a [List] of all the selected [Label]s.
Future<IList<Label>> showLabelPickerDialog(
  BuildContext context,
  IList<Label> labels,
) {
  return showDialog(
    context: context,
    builder: (context) => LabelPickerDialog(labels: labels),
  );
}

/// Widget that display a dialog that picks labels
class LabelPickerDialog extends StatefulWidget {
  final IList<Label> labels;

  LabelPickerDialog({Key key, this.labels}) : super(key: key);

  @override
  _LabelPickerDialogState createState() => _LabelPickerDialogState();
}

class _LabelPickerDialogState extends State<LabelPickerDialog>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LabelsBloc>(
      create: (context) => LabelsBloc(
        initialValue: widget.labels,
        repository: locator<LabelRepository>(),
      )..fetch(),
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(40.0),
        title: Text('select_labels_title').tr(),
        content: BlocBuilder<LabelsBloc, LabelsState>(
          builder: (context, state) {
            Widget contentWidget;

            if (state.isLoading)
              contentWidget = ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 200.0,
                  maxWidth: 300.0,
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            else if (state.hasError)
              contentWidget = ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 200.0,
                  maxWidth: 300.0,
                ),
                child: Center(
                  child: Text('no_label_to_display_msg').tr(),
                ),
              );
            else
              contentWidget = SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: state.labels
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
              );
            return AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 300),
              child: contentWidget,
            );
          },
        ),
        actions: [
          Builder(
            builder: (context) => TextButton(
              child: Text('save_btn').tr(),
              onPressed: () {
                locator<NavigationService>().pop(
                  result: context.read<LabelsBloc>().state.selected,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
