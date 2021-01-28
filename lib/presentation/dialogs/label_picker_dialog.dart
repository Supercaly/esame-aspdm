import 'package:aspdm_project/application/bloc/labels_bloc.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/repositories/label_repository.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/presentation/widgets/label_picker_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspdm_project/services/navigation_service.dart';

/// Display a dialog that picks the labels.
/// Passing an existing [List] of [labels] to mark them as already selected.
/// Returns a [List] of all the selected [Label]s.
Future<List<Label>> showLabelPickerDialog(
    BuildContext context, List<Label> labels) {
  return showDialog(
    context: context,
    builder: (context) => LabelPickerDialog(labels: labels),
  );
}

/// Widget that display a dialog that picks labels
class LabelPickerDialog extends StatefulWidget {
  final List<Label> labels;

  LabelPickerDialog({Key key, this.labels}) : super(key: key);

  @override
  _LabelPickerDialogState createState() => _LabelPickerDialogState();
}

class _LabelPickerDialogState extends State<LabelPickerDialog>
    with TickerProviderStateMixin {
  Set<Label> _selected;

  @override
  void initState() {
    super.initState();

    if (widget.labels != null && widget.labels.isNotEmpty)
      _selected = Set<Label>.from(widget.labels);
    else
      _selected = Set<Label>.identity();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(40.0),
      title: Text("Select Labels"),
      content: BlocProvider<LabelsBloc>(
        create: (context) => LabelsBloc(locator<LabelRepository>())..fetch(),
        child: BlocBuilder<LabelsBloc, LabelsState>(
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
                  child: Text("No label to display!"),
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
                            selected: _selected.contains(e),
                            onSelected: (selected) => setState(() {
                              if (selected)
                                _selected.add(e);
                              else
                                _selected.remove(e);
                            }),
                          ),
                        )
                        .toList(),
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
      ),
      actions: [
        TextButton(
          child: Text("SAVE"),
          onPressed: () {
            locator<NavigationService>().pop(
              result: _selected.toList(growable: false),
            );
          },
        ),
      ],
    );
  }
}
