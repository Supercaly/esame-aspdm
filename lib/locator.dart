import 'package:tasky/domain/repositories/label_repository.dart';
import 'package:tasky/domain/repositories/members_repository.dart';
import 'package:tasky/domain/repositories/task_form_repository.dart';
import 'package:tasky/infrastructure/repositories/archive_repository_impl.dart';
import 'package:tasky/infrastructure/repositories/auth_repository_impl.dart';
import 'package:tasky/infrastructure/repositories/home_repository_impl.dart';
import 'package:tasky/infrastructure/repositories/label_repository_impl.dart';
import 'package:tasky/infrastructure/repositories/members_repository_impl.dart';
import 'package:tasky/infrastructure/repositories/task_form_repository_imp.dart';
import 'package:tasky/infrastructure/repositories/task_repository_impl.dart';
import 'package:tasky/domain/repositories/archive_repository.dart';
import 'package:tasky/domain/repositories/auth_repository.dart';
import 'package:tasky/domain/repositories/home_repository.dart';
import 'package:tasky/domain/repositories/task_repository.dart';
import 'package:tasky/services/app_info_service.dart';
import 'package:tasky/services/connectivity_service.dart';
import 'package:tasky/infrastructure/datasources/remote_data_source.dart';
import 'package:tasky/services/link_service.dart';
import 'package:tasky/services/log_service.dart';
import 'package:tasky/services/navigation_service.dart';
import 'package:tasky/services/notification_service.dart';
import 'package:tasky/services/preference_service.dart';
import 'package:get_it/get_it.dart';

/// Instance of [GetIt] that can be used throughout the app.
GetIt locator = GetIt.instance;

/// Setup all the classes provided by the [locator].
Future<void> setupLocator() async {
  // Services
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<LogService>(() => LogService());
  locator.registerLazySingleton<NotificationService>(() => NotificationService(
        logService: locator<LogService>(),
      ));
  locator.registerLazySingleton<LinkService>(() => LinkService(
        logService: locator<LogService>(),
      ));

  final infoService = AppInfoService(logService: locator<LogService>());
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
      dataSource: locator<RemoteDataSource>(),
      preferenceService: locator<PreferenceService>(),
    ),
  );
  locator.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(dataSource: locator<RemoteDataSource>()),
  );
  locator.registerLazySingleton<ArchiveRepository>(
    () => ArchiveRepositoryImpl(dataSource: locator<RemoteDataSource>()),
  );
  locator.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(dataSource: locator<RemoteDataSource>()),
  );
  locator.registerLazySingleton<TaskFormRepository>(
    () => TaskFormRepositoryImpl(dataSource: locator<RemoteDataSource>()),
  );
  locator.registerLazySingleton<LabelRepository>(
    () => LabelRepositoryImpl(dataSource: locator<RemoteDataSource>()),
  );
  locator.registerLazySingleton<MembersRepository>(
    () => MembersRepositoryImpl(dataSource: locator<RemoteDataSource>()),
  );

  // Wait all singletons are ready before starting the app
  await locator.allReady();
}
