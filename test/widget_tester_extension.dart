import 'package:tasky/presentation/generated/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpLocalizedWidget(Widget child) async {
    await pumpWidget(
      EasyLocalization(
        supportedLocales: [Locale('en')],
        path: "path",
        saveLocale: false,
        assetLoader: CodegenLoader(),
        child: child,
      ),
    );
    await idle();
    await pumpAndSettle();
  }
}
