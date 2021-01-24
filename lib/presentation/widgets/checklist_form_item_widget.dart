import 'package:aspdm_project/application/bloc/checklist_form_bloc.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget that displays the title of the checklist letting the user
/// edit it. The edit events are automatically sent to the [ChecklistFormBloc].
class ChecklistFormTitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChecklistFormBloc, ChecklistFormState>(
      buildWhen: (_, __) => false,
      builder: (context, state) => TextFormField(
        initialValue: state.title.value.getOrNull() ?? "",
        keyboardType: TextInputType.text,
        maxLength: ChecklistTitle.maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        style: Theme.of(context).textTheme.headline6,
        decoration: InputDecoration(
          counterText: "",
        ),
        onChanged: (value) =>
            context.read<ChecklistFormBloc>().titleChanged(value),
        validator: (value) => ItemText(value).value.fold(
              (left) => "Invalid",
              (_) => null,
            ),
      ),
    );
  }
}

/// Widget that display an edit text that the user can use to add
/// a new item to the checklist. The new item is added automatically
/// to the [ChecklistFormBloc].
class ChecklistFormNewItemWidget extends StatefulWidget {
  @override
  _ChecklistFormNewItemWidgetState createState() =>
      _ChecklistFormNewItemWidgetState();
}

class _ChecklistFormNewItemWidgetState
    extends State<ChecklistFormNewItemWidget> {
  TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChecklistFormBloc, ChecklistFormState>(
      buildWhen: (_, __) => false,
      builder: (context, state) => Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
          width: double.maxFinite,
          child: TextFormField(
            controller: _controller,
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
                _controller.clear();
              }
            },
          ),
        ),
      ),
    );
  }
}

/// Widget that display a single item of a checklist letting the user
/// edit or remove it. The item is automatically changed or removed
/// from the [ChecklistFormBloc].
class ChecklistFormItem extends StatelessWidget {
  final ItemText item;
  final int index;

  ChecklistFormItem({
    Key key,
    this.item,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Row(
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
              decoration: InputDecoration(counterText: ""),
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
      ),
    );
  }
}
