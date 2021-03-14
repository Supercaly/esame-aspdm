import 'package:tasky/services/connectivity_service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  group("ConnectivityService Tests", () {
    late ConnectivityService connectivityService;
    late Connectivity mockConnectivity;

    setUpAll(() {
      mockConnectivity = MockConnectivity();
      connectivityService = ConnectivityService.private(mockConnectivity);
    });

    test("onConnectionStateChange emits true if the connection is active", () {
      when(mockConnectivity).calls(#onConnectivityChanged).thenAnswer(
            (_) => Stream.value(ConnectivityResult.wifi),
          );
      expect(
        connectivityService.onConnectionStateChange,
        emits(ConnectivityState.connected),
      );
    });

    test("onConnectionStateChange emits false if the connection is not active",
        () {
      when(mockConnectivity).calls(#onConnectivityChanged).thenAnswer(
            (_) => Stream.value(ConnectivityResult.none),
          );
      expect(
        connectivityService.onConnectionStateChange,
        emits(ConnectivityState.none),
      );
    });

    test("onConnectionStateChange emits when connection status changes", () {
      when(mockConnectivity).calls(#onConnectivityChanged).thenAnswer(
            (_) => Stream.fromIterable([
              ConnectivityResult.none,
              ConnectivityResult.mobile,
              ConnectivityResult.wifi,
              ConnectivityResult.none,
            ]),
          );
      expect(
          connectivityService.onConnectionStateChange,
          emitsInOrder([
            ConnectivityState.none,
            ConnectivityState.connected,
            ConnectivityState.connected,
            ConnectivityState.none,
          ]));
    });

    test("onConnectionStateChange emits error if there's an error", () {
      when(mockConnectivity).calls(#onConnectivityChanged).thenAnswer(
            (_) => Stream<ConnectivityResult>.error("Error"),
          );
      expect(
        connectivityService.onConnectionStateChange,
        emits(ConnectivityState.unknown),
      );
    });
  });
}
