import 'package:aspdm_project/domain/repositories/label_repository.dart';
import 'package:aspdm_project/domain/repositories/members_repository.dart';
import 'package:aspdm_project/infrastructure/repositories/archive_repository_impl.dart';
import 'package:aspdm_project/infrastructure/repositories/auth_repository_impl.dart';
import 'package:aspdm_project/infrastructure/repositories/home_repository_impl.dart';
import 'package:aspdm_project/infrastructure/repositories/label_repository_impl.dart';
import 'package:aspdm_project/infrastructure/repositories/members_repository_impl.dart';
import 'package:aspdm_project/infrastructure/repositories/task_repository_impl.dart';
import 'package:aspdm_project/domain/repositories/archive_repository.dart';
import 'package:aspdm_project/domain/repositories/auth_repository.dart';
import 'package:aspdm_project/domain/repositories/home_repository.dart';
import 'package:aspdm_project/domain/repositories/task_repository.dart';
import 'package:aspdm_project/services/app_info_service.dart';
import 'package:aspdm_project/services/connectivity_service.dart';
import 'package:aspdm_project/infrastructure/datasources/remote_data_source.dart';
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

  final infoService = AppInfoService(locator<LogService>());
  await infoService.init();
  locator.registerSingleton<AppInfoService>(infoService);

  final prefService = PreferenceService();
  await prefService.init();
  locator.registerSingleton<PreferenceService>(prefService);

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
  locator.registerLazySingleton<LabelRepository>(
    () => LabelRepositoryImpl(locator<RemoteDataSource>()),
  );
  locator.registerLazySingleton<MembersRepository>(
    () => MembersRepositoryImpl(locator<RemoteDataSource>()),
  );

  // Wait all singletons are ready before starting the app
  await locator.allReady();
}
