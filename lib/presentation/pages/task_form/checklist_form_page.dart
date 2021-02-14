import 'package:tasky/application/bloc/checklist_form_bloc.dart';
import 'package:tasky/locator.dart';
import 'package:tasky/presentation/pages/task_form/misc/checklist_primitive.dart';
import 'package:tasky/presentation/pages/task_form/widgets/checklist_form_item_widget.dart';
import 'package:tasky/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

/// Widget that displays a page that lets the user create or edit a given
/// [ChecklistPrimitive].
/// This page will be pushed with a MaterialPageRoot by the parent and not
/// by a normal named route like the other pages. This is done to reduce
/// the named routes since this page is only the mobile version of this screen.
///
/// see:
///   * [showChecklistFormDialog]
class ChecklistFormPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final ChecklistPrimitive primitive;

  ChecklistFormPage({Key key, this.primitive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChecklistFormBloc>(
      create: (context) => ChecklistFormBloc(initialValue: primitive),
      child: BlocListener<ChecklistFormBloc, ChecklistFormState>(
        listenWhen: (_, c) => c.isSave,
        listener: (context, state) =>
            locator<NavigationService>().pop(result: state.primitive),
        child: Scaffold(
          appBar: AppBar(
            title: SizedBox.shrink(),
            actions: [
              Builder(
                builder: (context) => TextButton(
                  child: Text('save_btn').tr(),
                  style: TextButton.styleFrom(primary: Colors.white),
                  onPressed: () {
                    if (_formKey.currentState.validate())
                      context.read<ChecklistFormBloc>().save();
                  },
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FeatherIcons.checkCircle),
                      SizedBox(width: 16.0),
                      Expanded(child: ChecklistFormTitleWidget()),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  BlocBuilder<ChecklistFormBloc, ChecklistFormState>(
                    buildWhen: (p, c) =>
                        p.primitive.items.length != c.primitive.items.length,
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
      ),
    );
  }
}
