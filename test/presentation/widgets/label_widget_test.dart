import 'package:tasky/domain/entities/label.dart';
import 'package:tasky/domain/values/label_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/presentation/widgets/label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../finders/container_by_color_finder.dart';

void main() {
  test("create widget with null label throws an error", () {
    try {
      LabelWidget(label: null);
      fail("This should throw an error!");
    } catch (e) {
      expect(e, isA<AssertionError>());
    }
  });

  testWidgets("show compact label", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LabelWidget(
            label: Label.test(
              id: UniqueId("mock_id"),
              color: LabelColor(Colors.red),
              label: LabelName("mock_label"),
            ),
            compact: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(ContainerByColorFinder(Colors.red), findsOneWidget);
    expect(find.text("mock_label"), findsNothing);
  });

  testWidgets("show extended label", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LabelWidget(
            label: Label.test(
              id: UniqueId("mock_id"),
              color: LabelColor(Colors.red),
              label: LabelName("mock_label"),
            ),
            compact: false,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(ContainerByColorFinder(Colors.red), findsOneWidget);
    expect(find.text("mock_label"), findsOneWidget);
  });
}
