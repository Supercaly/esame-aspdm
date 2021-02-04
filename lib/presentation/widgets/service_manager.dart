import 'package:aspdm_project/services/link_service.dart';
import 'package:aspdm_project/services/notification_service.dart';
import 'package:flutter/material.dart';

/// Widget that inject a [NotificationService] and a [LinkService]
/// into the widget tree.
class ServiceManager extends StatefulWidget {
  final NotificationService notificationService;
  final LinkService linkService;
  final Widget child;

  const ServiceManager({
    Key key,
    @required this.notificationService,
    @required this.linkService,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  _ServiceManagerState createState() => _ServiceManagerState();
}

class _ServiceManagerState extends State<ServiceManager> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    // Init the services
    widget.notificationService?.init();
    widget.linkService?.init();
  }

  @override
  void dispose() {
    // Dispose the services
    widget.notificationService?.close();
    super.dispose();
  }
}
