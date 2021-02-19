import 'package:sliding_sheet/sliding_sheet.dart';
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
/// Passing an existing [IList] of [labels] to mark them as already selected.
/// Returns a [IList] of all the selected [Label]s.
Future<IList<Label>> showLabelPickerSheet(
  BuildContext context,
  IList<Label> labels,
) {
  return showSlidingBottomSheet(
    context,
    resizeToAvoidBottomInset: false,
    parentBuilder: (context, sheet) => BlocProvider<LabelsBloc>(
      create: (context) => LabelsBloc(
        initialValue: labels,
        repository: locator<LabelRepository>(),
      )..fetch(),
      child: sheet,
    ),
    builder: (context) => SlidingSheetDialog(
      cornerRadius: 16.0,
      avoidStatusBar: true,
      cornerRadiusOnFullscreen: 0.0,
      snapSpec: SnapSpec(
        snap: true,
        initialSnap: 0.6,
        snappings: const [0.6, 1],
        positioning: SnapPositioning.relativeToAvailableSpace,
      ),
      headerBuilder: (context, state) => Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      result: context.read<LabelsBloc>().state.selected,
                    );
                  },
                  child: Text('save_btn').tr(),
                ),
              ],
            ),
          ],
        ),
      ),
      builder: (context, sheetState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocBuilder<LabelsBloc, LabelsState>(
            builder: (context, state) {
              if (state.isLoading)
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              else if (state.hasError || state.labels.isEmpty)
                return Material(
                  color: Theme.of(context).cardColor,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 250.0,
                      minHeight: 100.0,
                    ),
                    child: Center(
                      child: Text('no_label_to_display_msg').tr(),
                    ),
                  ),
                );
              else
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => LabelPickerItemWidget(
                    label: state.labels[index],
                    selected: state.selected.contains(state.labels[index]),
                    onSelected: (selected) {
                      if (selected)
                        context
                            .read<LabelsBloc>()
                            .selectLabel(state.labels[index]);
                      else
                        context
                            .read<LabelsBloc>()
                            .deselectLabel(state.labels[index]);
                    },
                  ),
                  itemCount: state.labels.length,
                );
            },
          ),
        );
      },
    ),
  );
}
