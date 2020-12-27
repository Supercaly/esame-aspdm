import 'dart:async';

import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService() : _connectivity = Connectivity();

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
        ),
      );
}
