import 'package:aspdm_project/application/bloc/labels_bloc.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

Future<List<Label>> showLabelPicker(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => LabelPickerDialog(),
  );
}

class LabelPickerDialog extends StatefulWidget {
  @override
  _LabelPickerDialogState createState() => _LabelPickerDialogState();
}

class _LabelPickerDialogState extends State<LabelPickerDialog>
    with TickerProviderStateMixin {
  Set<Label> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<Label>.identity();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select Labels"),
      content: BlocProvider<LabelsBloc>(
        create: (context) => LabelsBloc()..fetch(),
        child: BlocBuilder<LabelsBloc, LabelsState>(
          builder: (context, state) {
            return AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 300),
              child: (state.isLoading)
                  ? ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 200.0,
                        maxWidth: 300.0,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: state.labels
                          .map(
                            (e) => LabelPickerItemWidget(
                              label: e,
                              selected: _selected.contains(e),
                              onSelected: (selected) {
                                if (selected)
                                  setState(() {
                                    _selected.add(e);
                                  });
                                else
                                  setState(() {
                                    _selected.remove(e);
                                  });
                              },
                            ),
                          )
                          .toList(),
                    ),
            );
          },
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () {},
          child: Text("Done"),
        ),
      ],
    );
  }
}

class LabelPickerItemWidget extends StatelessWidget {
  final Label label;
  final bool selected;
  final void Function(bool value) onSelected;

  LabelPickerItemWidget({
    Key key,
    this.label,
    this.selected = false,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: label.color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          onTap: () => onSelected?.call(!selected),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: Text(
                label.label,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.white),
              )),
              if (selected)
                Icon(
                  FeatherIcons.check,
                  color: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
