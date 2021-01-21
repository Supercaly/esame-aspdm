import 'package:aspdm_project/application/bloc/labels_bloc.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/repositories/label_repository.dart';
import 'package:aspdm_project/presentation/widgets/label_picker_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import '../../locator.dart';

/// Display a bottom sheet that picks the labels.
/// Passing an existing [List] of [labels] to mark them as already selected.
/// Returns a [List] of all the selected [Label]s.
Future<List<Label>> showLabelPickerSheet(
  BuildContext context,
  List<Label> labels,
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
class LabelPickerSheet extends StatefulWidget {
  final List<Label> labels;

  LabelPickerSheet({Key key, this.labels}) : super(key: key);

  @override
  _LabelPickerSheetState createState() => _LabelPickerSheetState();
}

class _LabelPickerSheetState extends State<LabelPickerSheet> {
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: BlocProvider<LabelsBloc>(
        create: (context) => LabelsBloc(locator<LabelRepository>())..fetch(),
        child: BlocBuilder<LabelsBloc, LabelsState>(
          builder: (context, state) {
            Widget contentWidget;

            if (state.isLoading)
              contentWidget = Center(child: CircularProgressIndicator());
            else if (state.hasError)
              contentWidget = Center(child: Text("No Label to display!"));
            else
              contentWidget = CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate.fixed(
                      state.labels
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
                ],
              );

            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select Labels",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    FlatButton(
                      onPressed: () {
                        locator<NavigationService>().pop(
                          result: _selected.toList(growable: false),
                        );
                      },
                      child: Text("Done"),
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
