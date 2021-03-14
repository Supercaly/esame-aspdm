import 'package:tasky/services/app_info_service.dart';
import 'package:tasky/services/log_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info/package_info.dart';

import '../mocks/mock_log_service.dart';

class MockPackageInfo extends Mock implements PackageInfo {}

void main() {
  group("AppInfoService Tests", () {
    TestWidgetsFlutterBinding.ensureInitialized();

    late PackageInfo packageInfo;
    late LogService logService;

    setUpAll(() {
      logService = MockLogService();
      packageInfo = MockPackageInfo();

      when(packageInfo).calls(#appName).thenReturn("mock_app_name");
      when(packageInfo).calls(#packageName).thenReturn("mock.app.name");
      when(packageInfo).calls(#version).thenReturn("0.0.1");
      when(packageInfo).calls(#buildNumber).thenReturn("1");
    });

    tearDownAll(() {
    });

    test("return all parameters", () {
      final service = AppInfoService.private(packageInfo, logService);
      expect(service.appName, equals("mock_app_name"));
      expect(service.packageName, equals("mock.app.name"));
      expect(service.version, equals("0.0.1"));
      expect(service.buildNumber, equals("1"));
    });
  });
}
