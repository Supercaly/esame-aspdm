import 'package:aspdm_project/application/bloc/checklist_form_bloc.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class ChecklistFormPage extends StatefulWidget {
  @override
  _ChecklistFormPageState createState() => _ChecklistFormPageState();
}

class _ChecklistFormPageState extends State<ChecklistFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _itemController;

  @override
  void initState() {
    super.initState();
    _itemController = TextEditingController();
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: SizedBox.shrink(),
        actions: [
          TextButton(
            child: Text("Done"),
            onPressed: () {
              if (_formKey.currentState.validate())
                context.read<ChecklistFormBloc>().save();
            },
          ),
        ],
        backgroundColor: Colors.white,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Form(
          key: _formKey,
          child: BlocProvider<ChecklistFormBloc>(
            create: (context) => ChecklistFormBloc(),
            child: BlocListener<ChecklistFormBloc, ChecklistFormState>(
              listenWhen: (_, c) => c.isSave,
              listener: (context, state) =>
                  locator<NavigationService>().pop(result: state.primitive),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FeatherIcons.checkCircle),
                      SizedBox(width: 16.0),
                      Expanded(
                        child:
                            BlocBuilder<ChecklistFormBloc, ChecklistFormState>(
                          buildWhen: (_, __) => false,
                          builder: (context, state) => TextFormField(
                            initialValue: state.title,
                            keyboardType: TextInputType.text,
                            maxLength: ItemText.maxLength,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            style: Theme.of(context).textTheme.headline6,
                            decoration: InputDecoration(
                              counterText: "",
                            ),
                            onChanged: (value) => context
                                .read<ChecklistFormBloc>()
                                .titleChanged(value),
                            validator: (value) => ItemText(value).value.fold(
                                  (left) => "Invalid",
                                  (_) => null,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  BlocBuilder<ChecklistFormBloc, ChecklistFormState>(
                    buildWhen: (p, c) => p.items.length != c.items.length,
                    builder: (context, state) => Column(
                      children: state.items
                          .mapIndexed((idx, e) => ChecklistSheetItem(
                                key: ValueKey(e),
                                item: e,
                                index: idx,
                              ))
                          .toList(),
                    ),
                  ),
                  BlocBuilder<ChecklistFormBloc, ChecklistFormState>(
                    buildWhen: (_, __) => false,
                    builder: (context, state) => Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        controller: _itemController,
                        decoration: InputDecoration(
                          hintText: "Add item...",
                          counterText: "",
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        maxLength: ItemText.maxLength,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        minLines: 1,
                        maxLines: 6,
                        onFieldSubmitted: (value) {
                          final newItem = ItemText(value);
                          if (newItem.value.isRight()) {
                            context.read<ChecklistFormBloc>().addItem(newItem);
                            _itemController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChecklistSheetItem extends StatelessWidget {
  final ItemText item;
  final int index;

  ChecklistSheetItem({
    Key key,
    this.item,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 8.0),
        Checkbox(value: false, onChanged: (_) {}),
        SizedBox(width: 16.0),
        Expanded(
          child: TextFormField(
            maxLength: ItemText.maxLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            minLines: 1,
            maxLines: 6,
            initialValue: item.value.getOrNull() ?? "",
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onChanged: (value) => context
                .read<ChecklistFormBloc>()
                .editItem(index, ItemText(value)),
            validator: (value) => ItemText(value).value.fold(
                  (left) => "Invalid",
                  (_) => null,
                ),
          ),
        ),
        IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              context.read<ChecklistFormBloc>().removeItem(index);
            })
      ],
    );
  }
}

extension IterableX<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E element) f) sync* {
    for (int i = 0; i < this.length; i++) yield f(i, this.elementAt(i));
  }
}
