
import 'package:aspdm_project/services/log_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton<LogService>(() => LogService());
}