import 'package:aspdm_project/core/maybe.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/presentation/app_widget.dart';
import 'package:aspdm_project/presentation/pages/archive_page.dart';
import 'package:aspdm_project/presentation/pages/task_form_page.dart';
import 'package:aspdm_project/presentation/pages/task_info_page.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  static const String main = "/";
  static const String archive = "/archive";
  static const String task = "/task";
  static const String taskForm = "/task-form";

  // TODO(#56): Extract the route arguments in onGenerateRoute
  // Add `onGenerateRoute` static method to `Routes` that creates each routes and extract the correct arguments from it automatically.
  // ```dart
  // static Route<dynamic> onGenerateRoute(RouteSettings settings) {
  //     final args = settings.arguments;
  //     switch (settings.name) {
  //       case Router.splashPage:
  //         return MaterialPageRoute<dynamic>(
  //           builder: (_) => SplashPage(),
  //           settings: settings,
  //         );
  //       case Router.noteFormPage:
  //         // extract the arguments
  //         return MaterialPageRoute<dynamic>(
  //           builder: (_) => NoteFormPage(editedNote: typedArgs.editedNote),
  //           settings: settings,
  //         );
  //     }
  //   }
  // ```
  /// Route generator callback used to build the app's named routes.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.main:
        return MaterialPageRoute(
          builder: (context) => RootWidget(),
          settings: settings,
        );
      case Routes.archive:
        return MaterialPageRoute(
          builder: (context) => ArchivePage(),
          settings: settings,
        );
      case Routes.task:
        return MaterialPageRoute(
          builder: (context) => TaskInfoPage(
            taskId: extractArguments<UniqueId>(settings),
          ),
          settings: settings,
        );
      case Routes.taskForm:
        return MaterialPageRoute(
          builder: (context) => TaskFormPage(
            task: extractArguments<Task>(settings),
          ),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
        throw InvalidRouteException(settings.name);
    }
  }

  /// Extract the arguments form the [RouteSettings] and returns them.
  /// Returns a [Maybe] with the argument type [T]; if there is no arguments
  /// or are of a different type [Nothing] will be returned.
  @visibleForTesting
  static Maybe<T> extractArguments<T>(RouteSettings settings) {
    try {
      if (settings.arguments == null) return Maybe<T>.nothing();
      return Maybe<T>.just(settings.arguments as T);
    } catch (_) {
      return Maybe<T>.nothing();
    }
  }
}

/// Class representing an [Exception] thrown when accessing an
/// unknown route.
class InvalidRouteException implements Exception {
  final String name;

  const InvalidRouteException(this.name);

  @override
  String toString() => "Unknown route with name: $name!";
}
