import 'package:aspdm_project/core/maybe.dart';
import 'package:flutter/material.dart';

class NavigationService {
  NavigationService() : _navigationKey = GlobalKey();

  @visibleForTesting
  NavigationService.private(this._navigationKey);

  final GlobalKey<NavigatorState> _navigationKey;

  /// Returns the [GlobalKey] associated with the [NavigatorState].
  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  /// Navigates to the [routeName] and pass given [arguments]
  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) =>
      _navigationKey.currentState.pushNamed(
        routeName,
        arguments: arguments,
      );

  /// Pops the current route returning given [result]
  void pop({dynamic result}) => _navigationKey.currentState.pop(result);

  /// Returns a [Maybe] with the route's argument of type [T]
  /// in the given [context].
  /// If the arguments can't be found [Nothing] is returned instead.
  Maybe<T> arguments<T>(BuildContext context) {
    try {
      final T arg = ModalRoute.of(context)?.settings?.arguments as T;
      if (arg != null) return Maybe<T>.just(arg);
      return Maybe<T>.nothing();
    } catch (e) {
      return Maybe<T>.nothing();
    }
  }
}
