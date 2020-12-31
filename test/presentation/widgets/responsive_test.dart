import 'package:aspdm_project/presentation/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("Responsive Tests", () {
    testWidgets("isSmall works on small screens", (tester) async {
      final Key buttonKey = Key("button");

      await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(500.0, 1000.0)),
          child: Scaffold(
            body: Builder(builder: (context) {
              return RaisedButton(
                  key: buttonKey,
                  onPressed: () {
                    final isSmall = Responsive.isSmall(context);
                    final isMedium = Responsive.isMedium(context);
                    final isLarge = Responsive.isLarge(context);

                    expect(isSmall, isTrue);
                    expect(isMedium, isFalse);
                    expect(isLarge, isFalse);
                  });
            }),
          ),
        ),
      ));

      await tester.tap(find.byKey(buttonKey));
      await tester.pumpAndSettle();
    });

    testWidgets("isMedium works on medium screens", (tester) async {
      final Key buttonKey = Key("button");

      tester.binding.window.physicalSizeTestValue = Size(800.0, 1000.0);

      await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(800.0, 1000.0)),
          child: Scaffold(
            body: Builder(builder: (context) {
              return RaisedButton(
                  key: buttonKey,
                  onPressed: () {
                    final isSmall = Responsive.isSmall(context);
                    final isMedium = Responsive.isMedium(context);
                    final isLarge = Responsive.isLarge(context);

                    expect(isSmall, isFalse);
                    expect(isMedium, isTrue);
                    expect(isLarge, isFalse);
                  });
            }),
          ),
        ),
      ));

      await tester.tap(find.byKey(buttonKey));
      await tester.pumpAndSettle();
    });

    testWidgets("isLarge works on large screens", (tester) async {
      final Key buttonKey = Key("button");

      await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(1400.0, 1000.0)),
          child: Scaffold(
            body: Builder(builder: (context) {
              return RaisedButton(
                  key: buttonKey,
                  onPressed: () {
                    final isSmall = Responsive.isSmall(context);
                    final isMedium = Responsive.isMedium(context);
                    final isLarge = Responsive.isLarge(context);

                    expect(isSmall, isFalse);
                    expect(isMedium, isFalse);
                    expect(isLarge, isTrue);
                  });
            }),
          ),
        ),
      ));

      await tester.tap(find.byKey(buttonKey));
      await tester.pumpAndSettle();
    });

    testWidgets("Responsive builds small widget", (tester) async {
      tester.binding.window.physicalSizeTestValue = Size(500.0, 1000.0);
      tester.binding.window.devicePixelRatioTestValue = 1;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Responsive(
            small: Text("small"),
            medium: Text("medium"),
            large: Text("large"),
          ),
        ),
      ));

      expect(find.text("small"), findsOneWidget);
      expect(find.text("medium"), findsNothing);
      expect(find.text("large"), findsNothing);
    });

    testWidgets("Responsive builds medium widget", (tester) async {
      tester.binding.window.physicalSizeTestValue = Size(800.0, 1000.0);
      tester.binding.window.devicePixelRatioTestValue = 1;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Responsive(
            small: Text("small"),
            medium: Text("medium"),
            large: Text("large"),
          ),
        ),
      ));

      expect(find.text("small"), findsNothing);
      expect(find.text("medium"), findsOneWidget);
      expect(find.text("large"), findsNothing);
    });

    testWidgets("Responsive builds large widget", (tester) async {
      tester.binding.window.physicalSizeTestValue = Size(1400.0, 1000.0);
      tester.binding.window.devicePixelRatioTestValue = 1;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Responsive(
            small: Text("small"),
            medium: Text("medium"),
            large: Text("large"),
          ),
        ),
      ));

      expect(find.text("small"), findsNothing);
      expect(find.text("medium"), findsNothing);
      expect(find.text("large"), findsOneWidget);
    });

    test("create Responsive with null parameters throws an error", () {
      try {
        Responsive(large: Container());
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        Responsive(small: Container());
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });
  });
}
