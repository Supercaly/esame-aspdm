import 'package:aspdm_project/services/notification_service.dart';
import 'package:flutter/material.dart';

/// Widget that inject a [NotificationService] into the widget
/// tree.
class NotificationManager extends StatefulWidget {
  final NotificationService notificationService;
  final Widget child;

  const NotificationManager({
    Key key,
    @required this.notificationService,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  _NotificationManagerState createState() => _NotificationManagerState();
}

class _NotificationManagerState extends State<NotificationManager> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    widget.notificationService?.init();
  }

  @override
  void dispose() {
    widget.notificationService?.close();
    super.dispose();
  }
}
