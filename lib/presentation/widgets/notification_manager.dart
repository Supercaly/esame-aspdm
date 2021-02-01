import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationManager extends StatefulWidget {
  final Widget child;

  const NotificationManager({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  _NotificationManagerState createState() => _NotificationManagerState();
}

class _NotificationManagerState extends State<NotificationManager> {
  NotificationService _notificationService;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    super.initState();

    _notificationService = NotificationService(locator<LogService>());
    _notificationService.init();
  }

  @override
  void dispose() {
    _notificationService?.close();
    _notificationService = null;
    super.dispose();
  }
}
