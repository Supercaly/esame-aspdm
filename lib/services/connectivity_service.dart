import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService() : _connectivity = Connectivity();

  @visibleForTesting
  ConnectivityService.private(this._connectivity);

  Stream<bool> get onConnectionStateChange =>
      _connectivity.onConnectivityChanged.asBroadcastStream().transform(
            StreamTransformer.fromHandlers(
              handleData: (data, sink) {
                if (data == ConnectivityResult.wifi ||
                    data == ConnectivityResult.mobile)
                  sink.add(true);
                else
                  sink.add(false);
              },
              handleError: (error, stackTrace, sink) {
                sink.addError(error, stackTrace);
              },
            ),
          );
}
