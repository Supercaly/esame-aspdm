import 'package:aspdm_project/data/color_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("color to json returns the correct color string", () {
    final Color red = Color(0xFFFF0000);
    final Color green = Color(0xFF00FF00);
    final Color blue = Color(0xFF0000FF);

    expect(colorToJson(red), equals("#FFFF0000"));
    expect(colorToJson(green), equals("#FF00FF00"));
    expect(colorToJson(blue), equals("#FF0000FF"));
  });

  test("color to json returns null on null color", () {
    expect(colorToJson(null), isNull);
  });

  test("color from json returns the correct color", () {
    final Color red = Color(0xFFFF0000);
    final Color green = Color(0xFF00FF00);
    final Color blue = Color(0xFF0000FF);

    // Color string in ARGB format
    expect(colorFromJson("#FFFF0000"), equals(red));
    expect(colorFromJson("#FF00FF00"), equals(green));
    expect(colorFromJson("#FF0000FF"), equals(blue));

    // Colors string in RGB format
    expect(colorFromJson("#FF0000"), equals(red));
    expect(colorFromJson("#00FF00"), equals(green));
    expect(colorFromJson("#0000FF"), equals(blue));
  });

  test("color from json returns null on null color string", () {
    expect(colorFromJson(null), isNull);
    expect(colorFromJson(""), isNull);

    try {
      colorFromJson("FF#Mock");
      fail("This should throw an exception!");
    } catch (e) {
      expect(e, isA<FormatException>());
    }
  });
}
