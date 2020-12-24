import 'package:flutter/material.dart';

/// Converts a [String] to a [Color].
Color colorFromJson(String colorStr) {
  if (colorStr != null && colorStr.isNotEmpty) {
    final buffer = StringBuffer();
    if (colorStr.length == 6 || colorStr.length == 7) buffer.write("FF");
    buffer.write(colorStr.replaceFirst("#", ""));
    return Color(int.parse(buffer.toString(), radix: 16));
  } else
    return null;
}

/// Converts a [Color] to a [String].
String colorToJson(Color color) {
  if (color != null) {
    StringBuffer colorStr = StringBuffer();
    colorStr.write("#");
    colorStr.write(color.alpha.toRadixString(16).padLeft(2, '0'));
    colorStr.write(color.red.toRadixString(16).padLeft(2, '0'));
    colorStr.write(color.green.toRadixString(16).padLeft(2, '0'));
    colorStr.write(color.blue.toRadixString(16).padLeft(2, '0'));
    return colorStr.toString().toUpperCase();
  } else
    return null;
}
