import 'package:tasky/application/bloc/checklist_form_bloc.dart';
import 'package:tasky/domain/entities/label.dart';
import 'package:tasky/locator.dart';
import 'package:tasky/presentation/pages/task_form/misc/checklist_primitive.dart';
import 'package:tasky/presentation/pages/task_form/widgets/checklist_form_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/services/navigation_service.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:easy_localization/easy_localization.dart';

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
        listener: (context, state) =>
            locator<NavigationService>().pop(result: state.primitive),
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
                        buildWhen: (p, c) =>
                            p.primitive.items.length !=
                            c.primitive.items.length,
                        builder: (context, state) => Column(
                          children: state.primitive.items
                              .mapIndexed(
                                (idx, e) => ChecklistFormItem(
                                  key: ValueKey("$idx-$e"),
                                  item: e,
                                ),
                              )
                              .asList(),
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
                  child: Text('save_btn').tr(),
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
