import 'dart:async';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/presentation/routes.dart';
import 'package:tasky/services/log_service.dart';
import 'package:tasky/services/navigation_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final LogService _logService;
  final NavigationService _navigationService;
  final FirebaseMessaging _messaging;
  StreamSubscription<RemoteMessage> _onMessageOpenedAppSub;
  bool _initialized;

  NotificationService({
    @required NavigationService navigationService,
    @required LogService logService,
  })  : _navigationService = navigationService,
        _logService = logService,
        _messaging = FirebaseMessaging.instance,
        _initialized = false;

  @visibleForTesting
  NotificationService.private(
    this._messaging,
    this._navigationService,
    this._logService,
  ) : _initialized = false;

  /// Initialize the [NotificationService].
  Future<void> init() async {
    // If already initialized return directly
    if (_initialized) return;

    // If the device is web skip the initialization
    if (kIsWeb) {
      _logService.warning(
          "NotificationService.init: Notifications for web are not supported!");
      return;
    }

    // Request permissions for displaying notification
    // On Android the permission is automatically granted so, since it's the
    // only supported platform, this should always be true. If for some reason
    // the permissions are not granted return immediately.
    final settings = await _messaging.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      _logService
          .warning("NotificationService.init: Notifications not authorized!");
      return;
    }

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
    _initialized = true;
  }

  /// Closes the [NotificationService].
  void close() {
    _onMessageOpenedAppSub?.cancel();
    _onMessageOpenedAppSub = null;
    _initialized = false;
  }

  /// This method will navigate to [Routes.task] if the message has
  /// a valid task id.
  void _handleNotification(RemoteMessage message) {
    final rawTaskId = (message?.data != null) ? message?.data["task_id"] : null;
    final taskId = UniqueId(rawTaskId);
    _logService.info("NotificationService: Open info page for task $taskId");
    if (taskId.value.isRight())
      _navigationService.navigateTo(Routes.task, arguments: taskId);
  }
}
