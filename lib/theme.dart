import 'package:aspdm_project/generated/gen_colors.g.dart';
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: EasyColors.primary,
  primaryColorBrightness: Brightness.dark,
  accentColor: EasyColors.secondary,
  accentColorBrightness: Brightness.dark,
  scaffoldBackgroundColor: EasyColors.background,
  buttonTheme: ButtonThemeData(
    buttonColor: EasyColors.secondary,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 0.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
    margin: const EdgeInsets.symmetric(vertical: 4.0),
  ),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  accentColor: EasyColors.secondary,
  accentColorBrightness: Brightness.dark,
  buttonTheme: ButtonThemeData(
    buttonColor: EasyColors.secondary,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 0.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
    margin: const EdgeInsets.symmetric(vertical: 4.0),
  ),
);

final ThemeData lightThemeDesktop = lightTheme.copyWith(
  cardTheme: CardTheme(
    elevation: 4.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
);

final ThemeData darkThemeDesktop = darkTheme.copyWith(
  cardTheme: CardTheme(
    elevation: 4.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
);
