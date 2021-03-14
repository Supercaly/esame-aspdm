import 'package:tasky/domain/entities/label.dart';
import 'package:tasky/domain/values/label_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/presentation/pages/task_form/widgets/label_picker_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../finders/material_by_color_finder.dart';

void main() {
  group("LabelPickerItemWidget tests", () {
    late Label label;

    setUpAll(() {
      label = Label.test(
        id: UniqueId.empty(),
        color: LabelColor(Colors.red),
        label: LabelName("label"),
      );
    });

    testWidgets("create one item", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LabelPickerItemWidget(
              label: label,
            ),
          ),
        ),
      );

      expect(find.text("label"), findsOneWidget);
      expect(MaterialByColorFinder(Colors.red), findsOneWidget);
      expect(find.byIcon(FeatherIcons.check), findsNothing);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LabelPickerItemWidget(
              label: label,
              selected: true,
            ),
          ),
        ),
      );

      expect(find.text("label"), findsOneWidget);
      expect(MaterialByColorFinder(Colors.red), findsOneWidget);
      expect(find.byIcon(FeatherIcons.check), findsOneWidget);
    });

    testWidgets("tap on the item calls on selected", (tester) async {
      bool selected = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => LabelPickerItemWidget(
                label: label,
                selected: selected,
                onSelected: (value) => setState(() => selected = value),
              ),
            ),
          ),
        ),
      );

      expect(find.text("label"), findsOneWidget);
      expect(MaterialByColorFinder(Colors.red), findsOneWidget);
      expect(find.byIcon(FeatherIcons.check), findsNothing);

      await tester.tap(find.text("label"));
      await tester.pumpAndSettle();

      expect(find.text("label"), findsOneWidget);
      expect(MaterialByColorFinder(Colors.red), findsOneWidget);
      expect(find.byIcon(FeatherIcons.check), findsOneWidget);
    });
  });
}
