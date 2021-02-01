import 'dart:async';

import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/presentation/routes.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final LogService _logService;
  final FirebaseMessaging _messaging;
  StreamSubscription<RemoteMessage> _onMessageOpenedAppSub;
  bool _initialized;

  NotificationService(this._logService)
      : _messaging = FirebaseMessaging.instance,
        _initialized = false;

  Future<void> init() async {
    // If already initialized return directly
    if (_initialized) return;

    // If the device is web skip the initialization
    if (kIsWeb) {
      _logService.warning(
          "NotificationService: Notifications are not supported for web at the moment!");
      return;
    }

    final settings = await _messaging.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized)
      _logService.warning("NotificationService: Notifications not authorized!");

    // Catch the message that started the app.
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) _handleNotification(initialMessage);

    // Listen to all messages that resume the app from background
    _onMessageOpenedAppSub =
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message != null) _handleNotification(message);
    });

    // Sub to the topic
    _messaging.subscribeToTopic("newtask");
  }

  void close() {
    _onMessageOpenedAppSub?.cancel();
    _onMessageOpenedAppSub = null;
    _initialized = false;
  }

  void _handleNotification(RemoteMessage message) {
    final taskId = UniqueId(message?.data["task_id"]);
    _logService.info("NotificationService: Open info page for task $taskId");
    if (taskId.value.isRight())
      locator<NavigationService>().navigateTo(Routes.task, arguments: taskId);
  }
}
