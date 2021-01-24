import 'package:aspdm_project/application/bloc/checklist_form_bloc.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/presentation/misc/checklist_primitive.dart';
import 'package:aspdm_project/presentation/widgets/checklist_form_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:aspdm_project/presentation/pages/checklist_form_page.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

/// Display a dialog that picks the labels.
/// Passing an existing [List] of [labels] to mark them as already selected.
/// Returns a [List] of all the selected [Label]s.
Future<ChecklistPrimitive> showChecklistFormDialog(
  BuildContext context,
  ChecklistPrimitive primitive,
) {
  return showDialog(
    context: context,
    builder: (context) => ChecklistFormDialog(primitive: primitive),
  );
}

/// Widget that display a dialog with a checklist form.
class ChecklistFormDialog extends StatefulWidget {
  final ChecklistPrimitive primitive;

  ChecklistFormDialog({Key key, this.primitive}) : super(key: key);

  @override
  _ChecklistFormDialogState createState() => _ChecklistFormDialogState();
}

class _ChecklistFormDialogState extends State<ChecklistFormDialog>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChecklistFormBloc>(
      create: (context) => ChecklistFormBloc(initialValue: widget.primitive),
      child: BlocListener<ChecklistFormBloc, ChecklistFormState>(
        listenWhen: (_, c) => c.isSave,
        listener: (context, state) => locator<NavigationService>().pop(
          result: ChecklistPrimitive(title: state.title, items: state.items),
        ),
        child: Form(
          key: _formKey,
          child: AlertDialog(
            insetPadding: const EdgeInsets.all(40.0),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FeatherIcons.checkCircle),
                SizedBox(width: 16.0),
                Expanded(child: ChecklistFormTitleWidget()),
              ],
            ),
            content: AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 300),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BlocBuilder<ChecklistFormBloc, ChecklistFormState>(
                        buildWhen: (p, c) => p.items.length != c.items.length,
                        builder: (context, state) => Column(
                          children: state.items
                              .mapIndexed((idx, e) => ChecklistFormItem(
                                    key: ValueKey("${idx}_$e"),
                                    item: e,
                                    index: idx,
                                  ))
                              .toList(),
                        ),
                      ),
                      ChecklistFormNewItemWidget(),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Builder(
                builder: (context) => TextButton(
                  child: Text("Done"),
                  onPressed: () {
                    if (_formKey.currentState.validate())
                      context.read<ChecklistFormBloc>().save();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
