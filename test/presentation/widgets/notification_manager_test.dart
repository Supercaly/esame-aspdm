import 'package:aspdm_project/presentation/widgets/notification_manager.dart';
import 'package:aspdm_project/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  group("NotificationManager test", () {
    NotificationService service;

    setUp(() {
      service = MockNotificationService();
    });

    tearDown(() {
      service = null;
    });

    testWidgets("creating widget initializes the notification service",
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationManager(
              notificationService: service,
              child: Text("body"),
            ),
          ),
        ),
      );

      verify(service.init()).called(1);
    });

    testWidgets("disposing widget calls close on the notification service",
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationManager(
              notificationService: service,
              child: Text("body"),
            ),
          ),
        ),
      );
      verify(service.init()).called(1);

      await tester.pumpWidget(Container());
      verify(service.close()).called(1);
    });
  });
}
