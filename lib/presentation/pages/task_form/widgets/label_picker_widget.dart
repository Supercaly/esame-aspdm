import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:tasky/application/bloc/task_form_bloc.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/label.dart';
import 'package:tasky/presentation/pages/task_form/widgets/label_picker_dialog.dart';
import 'package:tasky/presentation/pages/task_form/widgets/label_picker_sheet.dart';
import 'package:tasky/presentation/widgets/label_widget.dart';
import 'package:tasky/presentation/widgets/responsive.dart';
import 'package:easy_localization/easy_localization.dart';

/// Widget that lets the user pick the labels.
class LabelPickerWidget extends StatelessWidget {
  const LabelPickerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskFormBloc, TaskFormState>(
      builder: (context, state) => ListTile(
        leading: Icon(FeatherIcons.tag),
        title: (state.taskPrimitive.labels.isNotEmpty)
            ? Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: state.taskPrimitive.labels
                    .map((e) => LabelWidget(label: e))
                    .asList(),
              )
            : Text('labels_text').tr(),
        onTap: () async {
          IList<Label>? selectedLabels;
          if (Responsive.isSmall(context))
            selectedLabels = await showLabelPickerSheet(
              context,
              state.taskPrimitive.labels,
            );
          else
            selectedLabels = await showLabelPickerDialog(
              context,
              state.taskPrimitive.labels,
            );
          if (selectedLabels != null)
            context.read<TaskFormBloc>().labelsChanged(selectedLabels);
        },
      ),
    );
  }
}
