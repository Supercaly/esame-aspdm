import 'package:aspdm_project/domain/failures/server_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("ServerFailure tests", () {
    test("ServerFailure equalities", () {
      expect(ServerFailure.noInternet(), equals(ServerFailure.noInternet()));
      expect(ServerFailure.formatError("error_string"),
          equals(ServerFailure.formatError("error_string")));
      expect(ServerFailure.unexpectedError("error_string"),
          equals(ServerFailure.unexpectedError("error_string")));
      expect(ServerFailure.unexpectedError("error_string"),
          isNot(equals(ServerFailure.unexpectedError("error_string_2"))));
      expect(ServerFailure.badRequest("error_string"),
          equals(ServerFailure.badRequest("error_string")));
      expect(ServerFailure.badRequest("error_string"),
          isNot(equals(ServerFailure.badRequest("error_string_2"))));
      expect(ServerFailure.internalError("error_string"),
          equals(ServerFailure.internalError("error_string")));
      expect(ServerFailure.internalError("error_string"),
          isNot(equals(ServerFailure.internalError("error_string_2"))));

      expect(ServerFailure.noInternet(),
          isNot(equals(ServerFailure.formatError("error_string"))));
      expect(ServerFailure.noInternet(),
          isNot(equals(ServerFailure.unexpectedError("error_string"))));
      expect(ServerFailure.noInternet(),
          isNot(equals(ServerFailure.badRequest("error_string"))));
      expect(ServerFailure.noInternet(),
          isNot(equals(ServerFailure.internalError("error_string"))));

      expect(ServerFailure.formatError("error_string"),
          isNot(equals(ServerFailure.noInternet())));
      expect(ServerFailure.formatError("error_string"),
          isNot(equals(ServerFailure.unexpectedError("error_string"))));
      expect(ServerFailure.formatError("error_string"),
          isNot(equals(ServerFailure.badRequest("error_string"))));
      expect(ServerFailure.formatError("error_string"),
          isNot(equals(ServerFailure.internalError("error_string"))));

      expect(ServerFailure.unexpectedError("error_string"),
          isNot(equals(ServerFailure.noInternet())));
      expect(ServerFailure.unexpectedError("error_string"),
          isNot(equals(ServerFailure.formatError("error_string"))));
      expect(ServerFailure.unexpectedError("error_string"),
          isNot(equals(ServerFailure.badRequest("error_string"))));
      expect(ServerFailure.unexpectedError("error_string"),
          isNot(equals(ServerFailure.internalError("error_string"))));

      expect(ServerFailure.badRequest("error_string"),
          isNot(equals(ServerFailure.noInternet())));
      expect(ServerFailure.badRequest("error_string"),
          isNot(equals(ServerFailure.formatError("error_string"))));
      expect(ServerFailure.badRequest("error_string"),
          isNot(equals(ServerFailure.unexpectedError("error_string"))));
      expect(ServerFailure.badRequest("error_string"),
          isNot(equals(ServerFailure.internalError("error_string"))));

      expect(ServerFailure.internalError("error_string"),
          isNot(equals(ServerFailure.noInternet())));
      expect(ServerFailure.internalError("error_string"),
          isNot(equals(ServerFailure.formatError("error_string"))));
      expect(ServerFailure.internalError("error_string"),
          isNot(equals(ServerFailure.unexpectedError("error_string"))));
      expect(ServerFailure.internalError("error_string"),
          isNot(equals(ServerFailure.badRequest("error_string"))));
    });

    test("when returns the result of the correct case", () {
      final r1 = ServerFailure.formatError("error_string").when(
        noInternet: () => false,
        internalError: (msg) => false,
        formatError: () => true,
        badRequest: (msg) => false,
        unexpectedError: (msg) => false,
      );
      final r2 = ServerFailure.noInternet().when(
        noInternet: () => true,
        internalError: (msg) => false,
        formatError: () => false,
        badRequest: (msg) => false,
        unexpectedError: (msg) => false,
      );
      final r3 = ServerFailure.unexpectedError("error_string").when(
        noInternet: () => false,
        internalError: (msg) => false,
        formatError: () => false,
        badRequest: (msg) => false,
        unexpectedError: (msg) => true,
      );
      final r4 = ServerFailure.badRequest("error_string").when(
        noInternet: () => false,
        internalError: (msg) => false,
        formatError: () => false,
        badRequest: (msg) => true,
        unexpectedError: (msg) => false,
      );
      final r5 = ServerFailure.internalError("error_string").when(
        noInternet: () => false,
        internalError: (msg) => true,
        formatError: () => false,
        badRequest: (msg) => false,
        unexpectedError: (msg) => false,
      );

      expect(r1, isTrue);
      expect(r2, isTrue);
      expect(r3, isTrue);
      expect(r4, isTrue);
      expect(r5, isTrue);
    });

    test("to string returns the correct representation", () {
      expect(ServerFailure.unexpectedError("mock_error").toString(),
          equals("ServerFailure: unexpected error: mock_error"));
      expect(ServerFailure.noInternet().toString(),
          equals("ServerFailure: no internet connection"));
      expect(ServerFailure.badRequest("mock_error").toString(),
          equals("ServerFailure: bad request: mock_error"));
      expect(ServerFailure.internalError("mock_error").toString(),
          equals("ServerFailure: internal error: mock_error"));
      expect(ServerFailure.formatError("mock_error").toString(),
          equals("ServerFailure: format error: mock_error"));
    });
  });
}
