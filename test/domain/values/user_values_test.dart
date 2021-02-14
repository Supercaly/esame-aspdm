import 'package:tasky/domain/values/user_values.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("UserName tests", () {
    test("create user name", () {
      final u1 = UserName("Mock User");
      expect(u1.value.getOrCrash(), equals("Mock User"));

      final longName = StringBuffer();
      for (var i = 0; i < 500; i++) longName.write("a");
      final u2 = UserName(longName.toString());
      expect(u2.value.isLeft(), isTrue);

      final u3 = UserName(null);
      expect(u3.value.isLeft(), isTrue);

      final u4 = UserName("");
      expect(u4.value.isLeft(), isTrue);
    });

    test("to string returns the correct representation", () {
      expect(UserName("Mock User").toString(), equals("UserName(Mock User)"));
      expect(UserName(null).toString(),
          equals("UserName(ValueFailure<String>.empty(value: null))"));
    });
  });

  group("EmailAddress tests", () {
    test("create email address", () {
      final u1 = EmailAddress("mock.email@test.com");
      expect(u1.value.getOrCrash(), equals("mock.email@test.com"));

      final u2 = EmailAddress("wrong email");
      expect(u2.value.isLeft(), isTrue);

      final u3 = EmailAddress(null);
      expect(u3.value.isLeft(), isTrue);
    });

    test("to string returns the correct representation", () {
      expect(EmailAddress("mock.email@test.com").toString(),
          equals("EmailAddress(mock.email@test.com)"));
      expect(
          EmailAddress(null).toString(),
          equals(
              "EmailAddress(ValueFailure<String>.invalidEmail(value: null))"));
    });
  });

  group("Password tests", () {
    test("create password", () {
      final u1 = Password("mock_password");
      expect(u1.value.getOrCrash(), equals("mock_password"));

      final u2 = Password("");
      expect(u2.value.isLeft(), isTrue);

      final u3 = Password(null);
      expect(u3.value.isLeft(), isTrue);
    });

    test("to string returns the correct representation", () {
      expect(Password("mock_password").toString(),
          equals("Password(mock_password)"));
      expect(
          Password(null).toString(),
          equals(
              "Password(ValueFailure<String>.invalidPassword(value: null))"));
    });
  });
}
