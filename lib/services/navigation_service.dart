// @dart=2.9
import 'package:flutter/material.dart';

class NavigationService {
  NavigationService() : _navigationKey = GlobalKey();

  @visibleForTesting
  NavigationService.private(this._navigationKey);

  final GlobalKey<NavigatorState> _navigationKey;

  /// Returns the [GlobalKey] associated with the [NavigatorState].
  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  /// Navigates to the [routeName] and pass given [arguments]
  Future<T> navigateTo<T>(String routeName, {dynamic arguments}) =>
      _navigationKey.currentState.pushNamed<T>(
        routeName,
        arguments: arguments,
      );

  /// Pops the current route returning given [result]
  void pop({dynamic result}) => _navigationKey.currentState.pop(result);

  /// Generate a [MaterialPageRoute] with the [builder] callback and
  /// navigates to it.
  Future<T> navigateToMaterialRoute<T>(
    Widget builder(BuildContext context), {
    bool fullscreenDialog = false,
  }) =>
      _navigationKey.currentState.push<T>(MaterialPageRoute(
        builder: builder,
        fullscreenDialog: fullscreenDialog,
      ));
}
