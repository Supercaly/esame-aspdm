class Routes {
  Routes._();

  static final String main = "/";
  static final String taskForm = "/task-form";
  static final String login = "/login";
  static final String archive = "/archive";
  static final String task = "/task";

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
}
