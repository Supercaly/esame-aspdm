import 'package:aspdm_project/services/app_info_service.dart';
import 'package:aspdm_project/services/data_source.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:aspdm_project/services/preference_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<LogService>(() => LogService());
  locator.registerLazySingleton<AppInfoService>(() => AppInfoService());
  locator.registerLazySingleton<PreferenceService>(() => PreferenceService());
  locator.registerLazySingleton<DataSource>(
    () => DataSource(),
    dispose: (param) => param.close(),
  );
}
