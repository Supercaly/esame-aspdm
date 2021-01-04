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

/// Instance of [GetIt] that can be used throughout the app.
GetIt locator = GetIt.instance;

/// Setup all the classes provided by the [locator].
Future<void> setupLocator() async {
  // Services
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<LogService>(() => LogService());
  locator.registerLazySingletonAsync<AppInfoService>(() async {
    final infoService = AppInfoService(locator<LogService>());
    await infoService.init();
    return infoService;
  });
  locator.registerLazySingletonAsync<PreferenceService>(() async {
    final prefService = PreferenceService();
    await prefService.init();
    return prefService;
  });
  locator.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(),
  );

  // Data sources
  locator.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSource(),
    dispose: (p) => p.close(),
  );

  // Repositories
  locator.registerSingletonAsync<AuthRepository>(
    () async => AuthRepositoryImpl(
      locator<RemoteDataSource>(),
      await locator.getAsync<PreferenceService>(),
    ),
    dependsOn: [PreferenceService],
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

  // Wait all singletons are ready before sarting the app
  await locator.allReady();
}
