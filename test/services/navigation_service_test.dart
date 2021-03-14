import 'package:tasky/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNavigatorObserver extends NavigatorObserver {
  bool _pop = false;
  bool _push = false;
  bool _replace = false;

  bool get pop => _pop;

  bool get push => _push;

  bool get replace => _replace;

  void clear() {
    _pop = false;
    _push = false;
    _replace = false;
  }

  @override
  void didPop(Route route, Route? previousRoute) => _pop = true;

  @override
  void didPush(Route route, Route? previousRoute) => _push = true;

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) => _replace = true;
}

void main() {
  group("NavigationService Tests", () {
    late NavigationService navigationService;
    late GlobalKey<NavigatorState> mockKey;
    late MockNavigatorObserver mockNavigatorObserver;

    tearDown(() {
      mockNavigatorObserver.clear();
    });

    setUpAll(() {
      mockKey = GlobalKey<NavigatorState>();
      mockNavigatorObserver = MockNavigatorObserver();
      navigationService = NavigationService.private(mockKey);
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
      expect(mockNavigatorObserver.push, isTrue);
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
      expect(mockNavigatorObserver.push, isTrue);

      navigationService.pop();
      await tester.pumpAndSettle();

      expect(find.text("First Screen"), findsOneWidget);
      expect(find.text("Second Screen"), findsNothing);
      expect(mockNavigatorObserver.pop, isTrue);
    });

    testWidgets("navigate to material route push the correct page to the stack",
        (tester) async {
      final firstRoute = Scaffold(
        body: Text("First Screen"),
      );
      final secondRouteBuilder = (BuildContext context) => Scaffold(
            body: Text("Second Screen"),
          );

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigationService.navigationKey,
          navigatorObservers: [mockNavigatorObserver],
          home: firstRoute,
        ),
      );

      expect(find.text("First Screen"), findsOneWidget);
      expect(find.text("Second Screen"), findsNothing);

      navigationService.navigateToMaterialRoute(secondRouteBuilder);
      await tester.pumpAndSettle();

      expect(find.text("First Screen"), findsNothing);
      expect(find.text("Second Screen"), findsOneWidget);
      expect(mockNavigatorObserver.push, isTrue);
    });

    testWidgets(
        "replaceWith pushed the selected route in place of the last route in the navigation stack",
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

      navigationService.replaceWith("second_route");
      await tester.pumpAndSettle();

      expect(find.text("First Screen"), findsNothing);
      expect(find.text("Second Screen"), findsOneWidget);
      expect(mockNavigatorObserver.replace, isTrue);
    });
  });
}
