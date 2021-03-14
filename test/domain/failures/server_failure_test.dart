import 'package:tasky/domain/failures/server_failure.dart';
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
      expect(ServerFailure.invalidArgument("argument", null),
          ServerFailure.invalidArgument("argument", null));
      expect(ServerFailure.invalidArgument("argument", null),
          isNot(ServerFailure.invalidArgument("argument_2", null)));
      expect(ServerFailure.uploadError(), ServerFailure.uploadError());

      expect(ServerFailure.noInternet(),
          isNot(equals(ServerFailure.formatError("error_string"))));
      expect(ServerFailure.noInternet(),
          isNot(equals(ServerFailure.unexpectedError("error_string"))));
      expect(ServerFailure.noInternet(),
          isNot(equals(ServerFailure.badRequest("error_string"))));
      expect(ServerFailure.noInternet(),
          isNot(equals(ServerFailure.internalError("error_string"))));
      expect(ServerFailure.noInternet(),
          isNot(equals(ServerFailure.invalidArgument("argument", null))));
      expect(ServerFailure.noInternet(),
          isNot(equals(ServerFailure.uploadError())));

      expect(ServerFailure.formatError("error_string"),
          isNot(equals(ServerFailure.noInternet())));
      expect(ServerFailure.formatError("error_string"),
          isNot(equals(ServerFailure.unexpectedError("error_string"))));
      expect(ServerFailure.formatError("error_string"),
          isNot(equals(ServerFailure.badRequest("error_string"))));
      expect(ServerFailure.formatError("error_string"),
          isNot(equals(ServerFailure.internalError("error_string"))));
      expect(ServerFailure.formatError("error_string"),
          isNot(equals(ServerFailure.invalidArgument("argument", null))));
      expect(ServerFailure.formatError("error_string"),
          isNot(equals(ServerFailure.uploadError())));

      expect(ServerFailure.unexpectedError("error_string"),
          isNot(equals(ServerFailure.noInternet())));
      expect(ServerFailure.unexpectedError("error_string"),
          isNot(equals(ServerFailure.formatError("error_string"))));
      expect(ServerFailure.unexpectedError("error_string"),
          isNot(equals(ServerFailure.badRequest("error_string"))));
      expect(ServerFailure.unexpectedError("error_string"),
          isNot(equals(ServerFailure.internalError("error_string"))));
      expect(ServerFailure.unexpectedError("error_string"),
          isNot(equals(ServerFailure.invalidArgument("argument", null))));
      expect(ServerFailure.unexpectedError("error_string"),
          isNot(equals(ServerFailure.uploadError())));

      expect(ServerFailure.badRequest("error_string"),
          isNot(equals(ServerFailure.noInternet())));
      expect(ServerFailure.badRequest("error_string"),
          isNot(equals(ServerFailure.formatError("error_string"))));
      expect(ServerFailure.badRequest("error_string"),
          isNot(equals(ServerFailure.unexpectedError("error_string"))));
      expect(ServerFailure.badRequest("error_string"),
          isNot(equals(ServerFailure.internalError("error_string"))));
      expect(ServerFailure.badRequest("error_string"),
          isNot(equals(ServerFailure.invalidArgument("argument", null))));
      expect(ServerFailure.badRequest("error_string"),
          isNot(equals(ServerFailure.uploadError())));

      expect(ServerFailure.internalError("error_string"),
          isNot(equals(ServerFailure.noInternet())));
      expect(ServerFailure.internalError("error_string"),
          isNot(equals(ServerFailure.formatError("error_string"))));
      expect(ServerFailure.internalError("error_string"),
          isNot(equals(ServerFailure.unexpectedError("error_string"))));
      expect(ServerFailure.internalError("error_string"),
          isNot(equals(ServerFailure.badRequest("error_string"))));
      expect(ServerFailure.internalError("error_string"),
          isNot(equals(ServerFailure.invalidArgument("argument", null))));
      expect(ServerFailure.internalError("error_string"),
          isNot(equals(ServerFailure.uploadError())));

      expect(ServerFailure.invalidArgument("argument", null),
          isNot(equals(ServerFailure.noInternet())));
      expect(ServerFailure.invalidArgument("argument", null),
          isNot(equals(ServerFailure.formatError("error_string"))));
      expect(ServerFailure.invalidArgument("argument", null),
          isNot(equals(ServerFailure.unexpectedError("error_string"))));
      expect(ServerFailure.invalidArgument("argument", null),
          isNot(equals(ServerFailure.badRequest("error_string"))));
      expect(ServerFailure.invalidArgument("argument", null),
          isNot(equals(ServerFailure.internalError("error_string"))));
      expect(ServerFailure.invalidArgument("argument", null),
          isNot(equals(ServerFailure.uploadError())));

      expect(ServerFailure.uploadError(),
          isNot(equals(ServerFailure.noInternet())));
      expect(ServerFailure.uploadError(),
          isNot(equals(ServerFailure.formatError("error_string"))));
      expect(ServerFailure.uploadError(),
          isNot(equals(ServerFailure.unexpectedError("error_string"))));
      expect(ServerFailure.uploadError(),
          isNot(equals(ServerFailure.badRequest("error_string"))));
      expect(ServerFailure.uploadError(),
          isNot(equals(ServerFailure.internalError("error_string"))));
      expect(ServerFailure.uploadError(),
          isNot(equals(ServerFailure.invalidArgument("argument", null))));
    });

    test("when returns the result of the correct case", () {
      final r1 = ServerFailure.formatError("error_string").when(
        noInternet: () => false,
        internalError: (msg) => false,
        formatError: (msg) => true,
        badRequest: (msg) => false,
        unexpectedError: (msg) => false,
        invalidArgument: (arg, received) => false,
        uploadError: () => false,
      );
      final r2 = ServerFailure.noInternet().when(
        noInternet: () => true,
        internalError: (msg) => false,
        formatError: (msg) => false,
        badRequest: (msg) => false,
        unexpectedError: (msg) => false,
        invalidArgument: (arg, received) => false,
        uploadError: () => false,
      );
      final r3 = ServerFailure.unexpectedError("error_string").when(
        noInternet: () => false,
        internalError: (msg) => false,
        formatError: (msg) => false,
        badRequest: (msg) => false,
        unexpectedError: (msg) => true,
        invalidArgument: (arg, received) => false,
        uploadError: () => false,
      );
      final r4 = ServerFailure.badRequest("error_string").when(
        noInternet: () => false,
        internalError: (msg) => false,
        formatError: (msg) => false,
        badRequest: (msg) => true,
        unexpectedError: (msg) => false,
        invalidArgument: (arg, received) => false,
        uploadError: () => false,
      );
      final r5 = ServerFailure.internalError("error_string").when(
        noInternet: () => false,
        internalError: (msg) => true,
        formatError: (msg) => false,
        badRequest: (msg) => false,
        unexpectedError: (msg) => false,
        invalidArgument: (arg, received) => false,
        uploadError: () => false,
      );
      final r6 = ServerFailure.invalidArgument("argument", null).when(
        noInternet: () => false,
        internalError: (msg) => false,
        formatError: (msg) => false,
        badRequest: (msg) => false,
        unexpectedError: (msg) => false,
        invalidArgument: (arg, received) => true,
        uploadError: () => false,
      );
      final r7 = ServerFailure.invalidArgument("argument", null).when(
        noInternet: () => false,
        internalError: (msg) => false,
        formatError: (msg) => false,
        badRequest: (msg) => false,
        unexpectedError: (msg) => false,
        invalidArgument: (arg, received) => true,
        uploadError: () => true,
      );

      expect(r1, isTrue);
      expect(r2, isTrue);
      expect(r3, isTrue);
      expect(r4, isTrue);
      expect(r5, isTrue);
      expect(r6, isTrue);
      expect(r7, isTrue);
    });
  });
}
