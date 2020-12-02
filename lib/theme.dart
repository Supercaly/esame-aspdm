import 'package:aspdm_project/generated/gen_colors.g.dart';
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: EasyColors.primary,
  primaryColorBrightness: Brightness.dark,
  accentColor: EasyColors.secondary,
  accentColorBrightness: Brightness.dark,
  scaffoldBackgroundColor: EasyColors.background,
);

final ThemeData darkTheme = ThemeData.dark();
