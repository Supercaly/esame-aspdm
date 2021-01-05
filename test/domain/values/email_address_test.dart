import 'package:aspdm_project/domain/values/email_address.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("create email address from correct value", () {
    final id = EmailAddress("mock@email.com");

    expect(id.value.isRight(), isTrue);
    expect(id.value.getOrNull(), equals("mock@email.com"));
  });

  test("create email address from wrong value", () {
    final id = EmailAddress("wrong_email_address");

    expect(id.value.isLeft(), isTrue);
  });

  test("create email address from null", () {
    final id = EmailAddress(null);

    expect(id.value.isLeft(), isTrue);
  });
}
