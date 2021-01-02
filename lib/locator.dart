import 'package:aspdm_project/data/repositories/archive_repository_impl.dart';
import 'package:aspdm_project/data/repositories/auth_repository_impl.dart';
import 'package:aspdm_project/data/repositories/home_repository_impl.dart';
import 'package:aspdm_project/data/repositories/task_repository_impl.dart';
import 'package:aspdm_project/domain/repositories/archive_repository.dart';
import 'package:aspdm_project/domain/repositories/auth_repository.dart';
import 'package:aspdm_project/domain/repositories/home_repository.dart';
import 'package:aspdm_project/domain/repositories/task_repository.dart';
import 'package:aspdm_project/services/app_info_service.dart';
import 'package:aspdm_project/services/connectivity_service.dart';
import 'package:aspdm_project/data/datasources/remote_data_source.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:aspdm_project/services/preference_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // Services
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<LogService>(() => LogService());
  locator.registerLazySingleton<AppInfoService>(() => AppInfoService());
  locator.registerLazySingleton<PreferenceService>(() => PreferenceService());
  locator.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(),
  );

  // Data sources
  locator.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSource(),
    dispose: (p) => p.close(),
  );

  // Repositories
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      locator<RemoteDataSource>(),
      locator<PreferenceService>(),
    ),
  );
  locator.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(locator<RemoteDataSource>()),
  );
  locator.registerLazySingleton<ArchiveRepository>(
    () => ArchiveRepositoryImpl(locator<RemoteDataSource>()),
  );
  locator.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(locator<RemoteDataSource>()),
  );
}
