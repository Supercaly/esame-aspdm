import 'package:tasky/presentation/widgets/service_manager.dart';
import 'package:tasky/services/link_service.dart';
import 'package:tasky/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNotificationService extends Mock implements NotificationService {}

class MockLinkService extends Mock implements LinkService {}

void main() {
  group("NotificationManager test", () {
    NotificationService notificationService;
    LinkService linkService;

    setUp(() {
      notificationService = MockNotificationService();
      linkService = MockLinkService();
    });

    tearDown(() {
      notificationService = null;
    });

    testWidgets("creating widget initializes the notification service",
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ServiceManager(
              notificationService: notificationService,
              linkService: linkService,
              child: Text("body"),
            ),
          ),
        ),
      );

      verify(notificationService.init()).called(1);
      verify(linkService.init()).called(1);
    });

    testWidgets("disposing widget calls close on the notification service",
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ServiceManager(
              notificationService: notificationService,
              linkService: linkService,
              child: Text("body"),
            ),
          ),
        ),
      );
      verify(notificationService.init()).called(1);
      verify(linkService.init()).called(1);

      await tester.pumpWidget(Container());
      verify(notificationService.close()).called(1);
    });

    test("create widget with null child throws an exception", () {
      try {
        ServiceManager(
          child: null,
          linkService: null,
          notificationService: null,
        );
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });
  });
}
