import 'package:aspdm_project/application/bloc/labels_bloc.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';

Future<List<Label>> showLabelPicker(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Select Labels"),
      content: BlocProvider<LabelsBloc>(
        create: (context) => LabelsBloc()..fetch(),
        child: BlocBuilder<LabelsBloc, LabelsState>(
          builder: (context, state) {
            if (state.isLoading)
              return Center(child: CircularProgressIndicator());
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: state.labels
                  .map(
                    (e) => LabelPickerItemWidget(
                      label: e,
                      selected: true,
                    ),
                  )
                  .toList(),
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
    ),
  );
}

class LabelPickerItemWidget extends StatelessWidget {
  final Label label;
  final bool selected;

  LabelPickerItemWidget({
    Key key,
    this.label,
    this.selected = false,
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
    );
  }
}
