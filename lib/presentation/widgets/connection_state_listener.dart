import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:tasky/services/connectivity_service.dart';

/// Widget that injects to the Widget tree a [ConnectivityService].
/// This widget will listen to [onConnectionStateChange] and display
/// a [SnackBar] every time the device in not connected.
class ConnectionStateListener extends StatelessWidget {
  /// Child Widget.
  final Widget child;

  /// Instance of [ConnectivityService].
  final ConnectivityService connectivityService;

  ConnectionStateListener({
    Key key,
    @required this.child,
    @required this.connectivityService,
  })  : assert(child != null),
        assert(connectivityService != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityState>(
      stream: connectivityService.onConnectionStateChange,
      initialData: ConnectivityState.unknown,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == ConnectivityState.none) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
              SnackBar(content: Text('device_offline_msg').tr()),
            );
          });
        }
        return child;
      },
    );
  }
}
