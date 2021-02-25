import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';

/// Enum representing all the possible
/// states of the device internet connection.
enum ConnectivityState {
  /// The device is connected to the internet.
  connected,

  /// The device is offline.
  none,

  /// The connection state can't be properly derived.
  unknown,
}

/// Server class that manages the internet connection status
/// exposing an API that notify other part of the app if
/// the device internet connection drops out.
class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService() : _connectivity = Connectivity();

  @visibleForTesting
  ConnectivityService.private(this._connectivity);

  /// Return a broadcast [Stream] of [ConnectivityState] that notifies
  /// the listeners every time the connection status changes.
  Stream<ConnectivityState> get onConnectionStateChange =>
      _connectivity.onConnectivityChanged.asBroadcastStream().transform(
            StreamTransformer.fromHandlers(
              handleData: (data, sink) {
                if (data == ConnectivityResult.wifi ||
                    data == ConnectivityResult.mobile)
                  sink.add(ConnectivityState.connected);
                else
                  sink.add(ConnectivityState.none);
              },
              handleError: (error, stackTrace, sink) {
                sink.add(ConnectivityState.unknown);
              },
            ),
          );
}
