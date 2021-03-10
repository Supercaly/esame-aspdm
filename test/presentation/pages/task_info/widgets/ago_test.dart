import 'package:easy_localization/easy_localization.dart';
import 'package:tasky/presentation/pages/task_info/widgets/ago.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../widget_tester_extension.dart';

void main() async {
  EasyLocalization.logger.enableBuildModes = [];
  await EasyLocalization.ensureInitialized();

  group("AgoTest test", () {
    testWidgets("create widget with valid time", (tester) async {
      await tester.pumpLocalizedWidget(
        Ago(
          time: DateTime.now().subtract(Duration(hours: 1)),
        ),
      );
      expect(find.text("about an hour ago"), findsOneWidget);
    });

    testWidgets("create widget with no time", (tester) async {
      await tester.pumpLocalizedWidget(
        Ago(
          placeholder: "no time",
        ),
      );
      expect(find.text("no time"), findsOneWidget);
    });

    test("format returns the correct string representation", () {
      expect(Ago.format(DateTime.now()), equals("a moment ago"));
      expect(Ago.format(DateTime.now().subtract(Duration(minutes: 1))),
          equals("a minute ago"));
      expect(Ago.format(DateTime.now().subtract(Duration(minutes: 5))),
          equals("5 minutes ago"));
      expect(Ago.format(DateTime.now().subtract(Duration(hours: 1))),
          equals("about an hour ago"));
      expect(Ago.format(DateTime.now().subtract(Duration(hours: 5))),
          equals("5 hours ago"));
      expect(Ago.format(DateTime.now().subtract(Duration(days: 1))),
          equals("a day ago"));
      expect(Ago.format(DateTime.now().subtract(Duration(days: 5))),
          equals("5 days ago"));
      expect(Ago.format(DateTime.now().subtract(Duration(days: 30))),
          equals("about a month ago"));
      expect(Ago.format(DateTime.now().subtract(Duration(days: 150))),
          equals("5 months ago"));
      expect(Ago.format(DateTime.now().subtract(Duration(days: 365))),
          equals("about a year ago"));
      expect(Ago.format(DateTime.now().subtract(Duration(days: 365 * 5))),
          equals("5 years ago"));

      expect(Ago.format(DateTime.now().add(Duration(minutes: 1))),
          equals("a minute from now"));
      expect(Ago.format(DateTime.now().add(Duration(minutes: 5))),
          equals("5 minutes from now"));
      expect(Ago.format(DateTime.now().add(Duration(hours: 1))),
          equals("about an hour from now"));
      expect(Ago.format(DateTime.now().add(Duration(hours: 5))),
          equals("5 hours from now"));
      expect(Ago.format(DateTime.now().add(Duration(days: 1))),
          equals("a day from now"));
      expect(Ago.format(DateTime.now().add(Duration(days: 5))),
          equals("5 days from now"));
      expect(Ago.format(DateTime.now().add(Duration(days: 30))),
          equals("about a month from now"));
      expect(Ago.format(DateTime.now().add(Duration(days: 150))),
          equals("5 months from now"));
      expect(Ago.format(DateTime.now().add(Duration(days: 365))),
          equals("about a year from now"));
      expect(Ago.format(DateTime.now().add(Duration(days: 365 * 5))),
          equals("5 years from now"));
    });
  });
}
