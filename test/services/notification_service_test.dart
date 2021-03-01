import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/services/log_service.dart';
import 'package:tasky/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/mock_log_service.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

void main() {
  group("NotificationService test", () {
    NotificationService service;
    FirebaseMessaging messaging;
    NotificationSettings permission;
    LogService logService;

    setUp(() {
      messaging = MockFirebaseMessaging();
      logService = MockLogService();
      service = NotificationService.private(
        messaging,
        logService,
      );
      permission = NotificationSettings(
        authorizationStatus: AuthorizationStatus.authorized,
        alert: AppleNotificationSetting.disabled,
        announcement: AppleNotificationSetting.disabled,
        badge: AppleNotificationSetting.disabled,
        carPlay: AppleNotificationSetting.disabled,
        lockScreen: AppleNotificationSetting.disabled,
        notificationCenter: AppleNotificationSetting.disabled,
        showPreviews: AppleShowPreviewSetting.never,
        sound: AppleNotificationSetting.disabled,
      );
      when(messaging).calls(#subscribeToTopic).thenReturn();
      when(logService).calls(#info).thenReturn();
    });

    tearDown(() {
      messaging = null;
      service = null;
      permission = null;
    });

    test("calling init multiple times has no effect", () async {
      when(messaging)
          .calls(#requestPermission)
          .thenAnswer((_) async => permission);
      when(messaging).calls(#getInitialMessage).thenAnswer((_) async => null);

      await service.init(onTaskOpen: (id) {});
      await service.init(onTaskOpen: (id) {});
      verify(messaging).called(#requestPermission).once();
      verify(messaging).called(#getInitialMessage).once();
    });

    test("null initial message has no effect", () async {
      when(messaging)
          .calls(#requestPermission)
          .thenAnswer((_) async => permission);
      when(messaging).calls(#getInitialMessage).thenAnswer((_) async => null);
      when(messaging).calls(#subscribeToTopic).thenReturn();
      bool opened = false;
      await service.init(onTaskOpen: (id) => opened = id.isJust());
      expect(opened, isFalse);
    });

    test("incorrect initial message has no effect", () async {
      when(messaging)
          .calls(#requestPermission)
          .thenAnswer((_) async => permission);
      when(messaging).calls(#getInitialMessage).thenAnswer((_) async =>
          RemoteMessage(notification: RemoteNotification(title: "Mock Title")));
      bool opened = false;
      await service.init(onTaskOpen: (id) => opened = id.isJust());
      expect(opened, isFalse);
    });

    test("correct initial message navigates to the task page", () async {
      when(messaging)
          .calls(#requestPermission)
          .thenAnswer((_) async => permission);
      when(messaging).calls(#getInitialMessage).thenAnswer(
          (_) async => RemoteMessage(data: {"task_id": "mock_task_id"}));
      bool opened = true;
      UniqueId taskId;
      await service.init(onTaskOpen: (id) {
        opened = id.isJust();
        taskId = id.getOrNull();
      });
      expect(opened, isTrue);
      expect(taskId, equals(UniqueId("mock_task_id")));
    });

    test("calling close un-initialize the service", () async {
      when(messaging)
          .calls(#requestPermission)
          .thenAnswer((_) async => permission);
      when(messaging).calls(#getInitialMessage).thenAnswer((_) async => null);
      await service.init(onTaskOpen: (id) {});
      service.close();
      await service.init(onTaskOpen: (id) {});
      verify(messaging).called(#requestPermission).times(2);
      verify(messaging).called(#getInitialMessage).times(2);
    });
  });
}
