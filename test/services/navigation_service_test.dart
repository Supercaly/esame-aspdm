import 'package:aspdm_project/core/maybe.dart';
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

    testWidgets(
        "arguments return a value when the route is pushed with something",
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        navigatorKey: navigationService.navigationKey,
        navigatorObservers: [mockNavigatorObserver],
        routes: {
          "/": (_) => FirstWidget(nav: navigationService, arg: 123),
          "/second": (_) => SecondWidget(nav: navigationService),
        },
      ));

      expect(find.text("navigate"), findsOneWidget);
      expect(find.text("123"), findsNothing);
      expect(find.text("nothing"), findsNothing);

      await tester.tap(find.text("navigate"));
      await tester.pumpAndSettle();

      expect(find.text("123"), findsOneWidget);
      expect(find.text("nothing"), findsNothing);
    });

    testWidgets(
        "arguments return nothing when the route is pushed without arguments",
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        navigatorKey: navigationService.navigationKey,
        navigatorObservers: [mockNavigatorObserver],
        routes: {
          "/": (_) => FirstWidget(nav: navigationService),
          "/second": (_) => SecondWidget(nav: navigationService),
        },
      ));

      expect(find.text("navigate"), findsOneWidget);
      expect(find.text("123"), findsNothing);
      expect(find.text("nothing"), findsNothing);

      await tester.tap(find.text("navigate"));
      await tester.pumpAndSettle();

      expect(find.text("123"), findsNothing);
      expect(find.text("nothing"), findsOneWidget);
    });

    testWidgets(
        "arguments return nothing when the route is pushed with argument of different type",
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        navigatorKey: navigationService.navigationKey,
        navigatorObservers: [mockNavigatorObserver],
        routes: {
          "/": (_) =>
              FirstWidget(nav: navigationService, arg: "not_the_value_i_want"),
          "/second": (_) => SecondWidget(nav: navigationService),
        },
      ));

      expect(find.text("navigate"), findsOneWidget);
      expect(find.text("123"), findsNothing);
      expect(find.text("nothing"), findsNothing);

      await tester.tap(find.text("navigate"));
      await tester.pumpAndSettle();

      expect(find.text("123"), findsNothing);
      expect(find.text("nothing"), findsOneWidget);
    });
  });
}

class FirstWidget extends StatelessWidget {
  final NavigationService nav;
  final dynamic arg;

  const FirstWidget({Key key, this.nav, this.arg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("navigate"),
          onPressed: () => nav.navigateTo("/second", arguments: arg),
        ),
      ),
    );
  }
}

class SecondWidget extends StatelessWidget {
  final NavigationService nav;

  const SecondWidget({Key key, this.nav}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Maybe<int> arg = nav.arguments(context);
    final text = arg.isNothing() ? "nothing" : "${arg.getOrNull()}";
    return Scaffold(
      body: Center(
        child: Text(text),
      ),
    );
  }
}
