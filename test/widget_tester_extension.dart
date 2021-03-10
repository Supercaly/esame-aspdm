import 'package:tasky/presentation/generated/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpLocalizedWidget(Widget child) async {
    await pumpWidget(_LocalizedScaffold(child: child));
    await idle();
    await pumpAndSettle();
  }
}

class _LocalizedScaffold extends StatelessWidget {
  final Widget child;

  const _LocalizedScaffold({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: [Locale('en')],
      path: "path",
      saveLocale: false,
      assetLoader: CodegenLoader(),
      child: Builder(
        builder: (context) => MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          home: Scaffold(
            body: child,
          ),
        ),
      ),
    );
  }
}
