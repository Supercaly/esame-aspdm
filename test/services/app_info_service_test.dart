// @dart=2.9
import 'package:tasky/services/app_info_service.dart';
import 'package:tasky/services/log_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info/package_info.dart';

import '../mocks/mock_log_service.dart';

class MockPackageInfo extends Mock implements PackageInfo {}

void main() {
  group("AppInfoService Tests", () {
    TestWidgetsFlutterBinding.ensureInitialized();

    PackageInfo packageInfo;
    LogService logService;

    setUpAll(() {
      logService = MockLogService();
      packageInfo = MockPackageInfo();

      when(packageInfo.appName).thenReturn("mock_app_name");
      when(packageInfo.packageName).thenReturn("mock.app.name");
      when(packageInfo.version).thenReturn("0.0.1");
      when(packageInfo.buildNumber).thenReturn("1");
    });

    tearDownAll(() {
      packageInfo = null;
      logService = null;
    });

    test("return all parameters", () {
      final service = AppInfoService.private(packageInfo, logService);
      expect(service.appName, equals("mock_app_name"));
      expect(service.packageName, equals("mock.app.name"));
      expect(service.version, equals("0.0.1"));
      expect(service.buildNumber, equals("1"));
    });

    test("unsupported platform returns default values", () {
      final service = AppInfoService.private(null, logService);
      expect(service.appName, "Tasky");
      expect(service.packageName, isNull);
      expect(service.version, equals("1.0.0"));
      expect(service.buildNumber, equals("1"));
    });
  });
}
