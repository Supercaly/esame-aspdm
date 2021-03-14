import 'package:tasky/presentation/widgets/service_manager.dart';
import 'package:tasky/services/link_service.dart';
import 'package:tasky/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationService extends Mock implements NotificationService {}

class MockLinkService extends Mock implements LinkService {}

void main() {
  group("NotificationManager test", () {
    late NotificationService notificationService;
    late LinkService linkService;

    setUp(() {
      notificationService = MockNotificationService();
      linkService = MockLinkService();
    });

    testWidgets("creating widget initializes the notification service",
        (tester) async {
      when(notificationService).calls(#init).thenReturn();
      when(notificationService).calls(#close).thenReturn();
      when(linkService).calls(#init).thenReturn();
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

      verify(notificationService).called(#init).once();
      verify(linkService).called(#init).once();
    });

    testWidgets("disposing widget calls close on the notification service",
        (tester) async {
      when(notificationService).calls(#init).thenReturn();
      when(notificationService).calls(#close).thenReturn();
      when(linkService).calls(#init).thenReturn();
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
      verify(notificationService).called(#init).once();
      verify(linkService).called(#init).once();

      await tester.pumpWidget(Container());
      verify(notificationService).called(#close).once();
    });
  });
}
