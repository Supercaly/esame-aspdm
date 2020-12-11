import 'package:flutter/material.dart';

/// Converts a [String] to a [Color].
Color colorFromJson(String colorStr) {
  int intColor = int.tryParse(colorStr ?? "", radix: 16);
  return intColor == null ? null : Color(intColor);
}

/// Converts a [Color] to a [String].
String colorToJson(Color color) => color?.value?.toRadixString(16);
