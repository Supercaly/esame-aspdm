import 'dart:async';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/services/log_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Class that manage the notifications sent and received
/// by the application.
class NotificationService {
  final LogService _logService;
  final FirebaseMessaging _messaging;
  StreamSubscription<RemoteMessage> _onMessageOpenedAppSub;
  bool _initialized;

  NotificationService({
    @required LogService logService,
  })  : _logService = logService,
        _messaging = FirebaseMessaging.instance,
        _initialized = false;

  @visibleForTesting
  NotificationService.private(
    this._messaging,
    this._logService,
  ) : _initialized = false;

  /// Initialize the [NotificationService].
  Future<void> init({
    @required void Function(Maybe<UniqueId> id) onTaskOpen,
  }) async {
    assert(onTaskOpen != null);

    // If already initialized return immediately
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
    if (initialMessage != null)
      onTaskOpen(_getTaskFromNotification(initialMessage));

    // Listen to all messages that resume the app from background
    _onMessageOpenedAppSub =
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message != null) onTaskOpen(_getTaskFromNotification(message));
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

  /// This method will return [Maybe] an [UniqueId] with the task id extracted
  /// from the notification message.
  Maybe<UniqueId> _getTaskFromNotification(RemoteMessage message) {
    final rawTaskId = (message?.data != null) ? message?.data["task_id"] : null;
    final taskId = UniqueId(rawTaskId);
    _logService.info("NotificationService: Received task with id $taskId");
    if (taskId.value.isRight())
      return Maybe.just(taskId);
    else
      return Maybe.nothing();
  }
}
