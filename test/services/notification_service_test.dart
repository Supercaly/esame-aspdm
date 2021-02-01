import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:aspdm_project/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mock_log_service.dart';
import '../mocks/mock_navigation_service.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

void main() {
  group("NotificationService test", () {
    NotificationService service;
    NavigationService navigation;
    FirebaseMessaging messaging;

    setUp(() {
      navigation = MockNavigationService();
      messaging = MockFirebaseMessaging();
      service = NotificationService.private(
        messaging,
        navigation,
        MockLogService(),
      );
    });

    tearDown(() {
      navigation = null;
      messaging = null;
      service = null;
    });

    test("calling init multiple times has no effect", () async {
      when(messaging.requestPermission()).thenAnswer(
        (_) async => NotificationSettings(
            authorizationStatus: AuthorizationStatus.authorized),
      );
      await service.init();
      await service.init();
      verify(messaging.requestPermission()).called(1);
      verify(messaging.getInitialMessage()).called(1);
    });

    test("null initial message has no effect", () async {
      when(messaging.requestPermission()).thenAnswer(
        (_) async => NotificationSettings(
            authorizationStatus: AuthorizationStatus.authorized),
      );
      when(messaging.getInitialMessage()).thenAnswer((_) async => null);
      await service.init();
      verifyNever(navigation.navigateTo(any, arguments: anyNamed("arguments")));
    });

    test("incorrect initial message has no effect", () async {
      when(messaging.requestPermission()).thenAnswer(
        (_) async => NotificationSettings(
            authorizationStatus: AuthorizationStatus.authorized),
      );
      when(messaging.getInitialMessage()).thenAnswer((_) async =>
          RemoteMessage(notification: RemoteNotification(title: "Mock Title")));

      await service.init();
      verifyNever(navigation.navigateTo(any, arguments: anyNamed("arguments")));
    });

    test("correct initial message navigates to the task page", () async {
      when(messaging.requestPermission()).thenAnswer(
        (_) async => NotificationSettings(
            authorizationStatus: AuthorizationStatus.authorized),
      );
      when(messaging.getInitialMessage()).thenAnswer(
          (_) async => RemoteMessage(data: {"task_id": "mock_task_id"}));

      await service.init();
      verify(navigation.navigateTo("/task",
              arguments: UniqueId("mock_task_id")))
          .called(1);
    });

    test("calling close un-initialize the service", () async {
      when(messaging.requestPermission()).thenAnswer(
        (_) async => NotificationSettings(
            authorizationStatus: AuthorizationStatus.authorized),
      );
      await service.init();
      service.close();
      await service.init();
      verify(messaging.requestPermission()).called(2);
      verify(messaging.getInitialMessage()).called(2);
    });
  });
}
