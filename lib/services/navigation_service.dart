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

  /// Returns the arguments of type [T] in the given [context].
  /// If the arguments can't be found `null` is returned instead.
  T arguments<T>(BuildContext context) {
    return ModalRoute.of(context)?.settings?.arguments as T;
  }
}
