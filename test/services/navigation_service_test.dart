import 'package:aspdm_project/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group("NavigationService Tests", () {
    NavigationService navigationService;
    GlobalKey<NavigatorState> mockKey;
    NavigatorObserver mockNavigatorObserver;

    setUpAll(() {
      mockKey = GlobalKey<NavigatorState>();
      mockNavigatorObserver = MockNavigatorObserver();
      navigationService = NavigationService.private(mockKey);
    });

    tearDownAll(() {
      mockKey = null;
      mockNavigatorObserver = null;
      navigationService = null;
    });

    test("get navigation key", () {
      expect(navigationService.navigationKey, equals(mockKey));
    });

    testWidgets(
        "navigateTo pushed the selected route into the navigation stack",
        (tester) async {
      final firstRoute = MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Text("First Screen"),
        ),
      );
      final secondRoute = MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Text("Second Screen"),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigationService.navigationKey,
          navigatorObservers: [mockNavigatorObserver],
          initialRoute: "first_route",
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case "first_route":
                return firstRoute;
              case "second_route":
                return secondRoute;
              default:
                return null;
            }
          },
        ),
      );

      expect(find.text("First Screen"), findsOneWidget);
      expect(find.text("Second Screen"), findsNothing);

      navigationService.navigateTo("second_route");
      await tester.pumpAndSettle();

      expect(find.text("First Screen"), findsNothing);
      expect(find.text("Second Screen"), findsOneWidget);
      verify(mockNavigatorObserver.didPush(secondRoute, firstRoute));
    });

    testWidgets("pop remove the current route onto the navigation stack",
        (tester) async {
      final firstRoute = MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Text("First Screen"),
        ),
      );
      final secondRoute = MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Text("Second Screen"),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigationService.navigationKey,
          navigatorObservers: [mockNavigatorObserver],
          initialRoute: "first_route",
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case "first_route":
                return firstRoute;
              case "second_route":
                return secondRoute;
              default:
                return null;
            }
          },
        ),
      );

      expect(find.text("First Screen"), findsOneWidget);
      expect(find.text("Second Screen"), findsNothing);

      navigationService.navigateTo("second_route");
      await tester.pumpAndSettle();

      expect(find.text("First Screen"), findsNothing);
      expect(find.text("Second Screen"), findsOneWidget);
      verify(mockNavigatorObserver.didPush(secondRoute, firstRoute));

      navigationService.pop();
      await tester.pumpAndSettle();

      expect(find.text("First Screen"), findsOneWidget);
      expect(find.text("Second Screen"), findsNothing);
      verify(mockNavigatorObserver.didPop(secondRoute, firstRoute));
    });
  });
}
