import 'package:tasky/services/connectivity_service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  group("ConnectivityService Tests", () {
    ConnectivityService connectivityService;
    Connectivity mockConnectivity;

    setUpAll(() {
      mockConnectivity = MockConnectivity();
      connectivityService = ConnectivityService.private(mockConnectivity);
    });

    test("onConnectionStateChange emits true if the connection is active", () {
      when(mockConnectivity.onConnectivityChanged).thenAnswer(
        (_) => Stream.value(ConnectivityResult.wifi),
      );
      expect(connectivityService.onConnectionStateChange, emits(true));
    });

    test("onConnectionStateChange emits false if the connection is not active",
        () {
      when(mockConnectivity.onConnectivityChanged).thenAnswer(
        (_) => Stream.value(ConnectivityResult.none),
      );
      expect(connectivityService.onConnectionStateChange, emits(false));
    });

    test("onConnectionStateChange emits when connection status changes", () {
      when(mockConnectivity.onConnectivityChanged).thenAnswer(
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
            false,
            true,
            true,
            false,
          ]));
    });

    test("onConnectionStateChange emits error if there's an error", () {
      when(mockConnectivity.onConnectivityChanged).thenAnswer(
        (_) => Stream.error("Error"),
      );
      expect(connectivityService.onConnectionStateChange, emitsError("Error"));
    });
  });
}
