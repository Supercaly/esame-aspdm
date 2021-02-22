import 'package:flutter/material.dart';
import 'package:tasky/locator.dart';
import 'package:tasky/services/navigation_service.dart';
import 'package:easy_localization/easy_localization.dart';

/// Show a confirm dialog before archiving a task.
Future<bool> showArchiveConfirmDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('archive_dialog_title').tr(),
      content: Text('archive_dialog_msg').tr(),
      actions: [
        TextButton(
          onPressed: () => locator<NavigationService>().pop(result: false),
          child: Text('cancel_btn').tr(),
        ),
        TextButton(
          onPressed: () => locator<NavigationService>().pop(result: true),
          child: Text('archive_btn').tr(),
        ),
      ],
    ),
  );
}

/// Show a confirm dialog before un-archiving a task.
Future<bool> showUnarchiveConfirmDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('unarchive_dialog_title').tr(),
      content: Text('unarchive_dialog_msg').tr(),
      actions: [
        TextButton(
          onPressed: () => locator<NavigationService>().pop(result: false),
          child: Text('cancel_btn').tr(),
        ),
        TextButton(
          onPressed: () => locator<NavigationService>().pop(result: true),
          child: Text('unarchive_btn').tr(),
        ),
      ],
    ),
  );
}
