import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:tasky/application/bloc/task_form_bloc.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/presentation/pages/task_form/misc/date_time_extension.dart';

/// Widget that lets the user pick an expiring date.
class DatePickerWidget extends StatelessWidget {
  const DatePickerWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskFormBloc, TaskFormState>(
      buildWhen: (p, c) =>
          p.taskPrimitive.expireDate != c.taskPrimitive.expireDate,
      builder: (context, state) => ListTile(
        leading: Icon(FeatherIcons.calendar),
        title: (state.taskPrimitive.expireDate.getOrNull() != null)
            ? Text(DateFormat("dd MMM y HH:mm")
                .format(state.taskPrimitive.expireDate.getOrNull()))
            : Text('expiration_date_text').tr(),
        trailing: IconButton(
          icon: Icon(Icons.close),
          onPressed: () =>
              context.read<TaskFormBloc>().dateChanged(Maybe.nothing()),
        ),
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate:
                state.taskPrimitive.expireDate.getOrElse(() => DateTime.now()),
            firstDate: DateTime(2000),
            lastDate: DateTime(2030),
          );
          if (pickedDate != null) {
            // Pick the time
            final pickedTime = await showTimePicker(
              context: context,
              initialTime: state.taskPrimitive.expireDate
                  .getOrElse(() => DateTime.now())
                  .toTime(),
            );
            if (pickedTime != null) {
              context
                  .read<TaskFormBloc>()
                  .dateChanged(Maybe.just(pickedDate.combine(pickedTime)));
            }
          }
        },
      ),
    );
  }
}
