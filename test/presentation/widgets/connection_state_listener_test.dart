import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasky/presentation/widgets/connection_state_listener.dart';
import 'package:tasky/services/connectivity_service.dart';
import '../../widget_tester_extension.dart';

class MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  group("ConnectionStateListener test", () {
    ConnectivityService service;

    setUpAll(() {
      service = MockConnectivityService();
    });

    testWidgets("init with connected don't show the snack bar", (tester) async {
      when(service.onConnectionStateChange)
          .thenAnswer((_) => Stream.value(ConnectivityState.connected));

      await tester.pumpLocalizedWidget(
        MaterialApp(
          home: Scaffold(
            body: ConnectionStateListener(
              child: Text("body"),
              connectivityService: service,
            ),
          ),
        ),
      );

      expect(find.text("body"), findsOneWidget);
      expect(find.text("The device is offline!"), findsNothing);
    });

    testWidgets("init with unknown don't show the snack bar", (tester) async {
      when(service.onConnectionStateChange)
          .thenAnswer((_) => Stream.value(ConnectivityState.unknown));

      await tester.pumpLocalizedWidget(
        MaterialApp(
          home: Scaffold(
            body: ConnectionStateListener(
              child: Text("body"),
              connectivityService: service,
            ),
          ),
        ),
      );

      expect(find.text("body"), findsOneWidget);
      expect(find.text("The device is offline!"), findsNothing);
    });

    testWidgets("init with none show the snack bar", (tester) async {
      when(service.onConnectionStateChange)
          .thenAnswer((_) => Stream.value(ConnectivityState.none));

      await tester.pumpLocalizedWidget(
        MaterialApp(
          home: Scaffold(
            body: ConnectionStateListener(
              child: Text("body"),
              connectivityService: service,
            ),
          ),
        ),
      );

      expect(find.text("body"), findsOneWidget);
      expect(find.text("The device is offline!"), findsOneWidget);
    });

    testWidgets("state changes show the snack bar", (tester) async {
      when(service.onConnectionStateChange).thenAnswer(
        (_) => Stream.fromIterable([
          ConnectivityState.connected,
          ConnectivityState.none,
        ]),
      );

      await tester.pumpLocalizedWidget(
        MaterialApp(
          home: Scaffold(
            body: ConnectionStateListener(
              child: Text("body"),
              connectivityService: service,
            ),
          ),
        ),
      );

      await tester.pump(Duration.zero);
      expect(find.text("body"), findsOneWidget);
      expect(find.text("The device is offline!"), findsOneWidget);
    });
  });
}
