import 'package:tasky/application/bloc/auth_bloc.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/locator.dart';
import 'package:tasky/presentation/routes.dart';
import 'package:tasky/services/link_service.dart';
import 'package:tasky/services/navigation_service.dart';
import 'package:tasky/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Widget that inject a [NotificationService] and a [LinkService]
/// into the widget tree.
class ServiceManager extends StatefulWidget {
  final NotificationService? notificationService;
  final LinkService? linkService;
  final Widget child;

  const ServiceManager({
    Key? key,
    required this.notificationService,
    required this.linkService,
    required this.child,
  })  : super(key: key);

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
    widget.notificationService?.init(onTaskOpen: _handleTaskOpen);
    widget.linkService?.init(onTaskOpen: _handleTaskOpen);
  }

  @override
  void dispose() {
    // Dispose the services
    widget.notificationService?.close();
    super.dispose();
  }

  void _handleTaskOpen(Maybe<UniqueId> taskId) {
    // If the given taskId is nothing return immediately
    if (taskId.isNothing()) return;
    // Get the current AuthState and if the user is authenticated navigate
    // to the task info page passing the given taskId that is valid.
    context.read<AuthBloc>().state.when(
          initial: (_) {},
          authenticated: (_) {
            locator<NavigationService>()
                .navigateTo(Routes.task, arguments: taskId.getOrCrash());
          },
          unauthenticated: (_) {},
        );
  }
}
