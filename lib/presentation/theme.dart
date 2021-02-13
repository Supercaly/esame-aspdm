import 'package:tasky/presentation/generated/gen_colors.g.dart';
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: EasyColors.primary,
  primaryColorBrightness: Brightness.dark,
  accentColor: EasyColors.secondary,
  accentColorBrightness: Brightness.dark,
  scaffoldBackgroundColor: EasyColors.background,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: EasyColors.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 0.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
    margin: const EdgeInsets.symmetric(vertical: 4.0),
  ),
  bottomNavigationBarTheme:
      BottomNavigationBarThemeData(selectedItemColor: EasyColors.secondary),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) return EasyColors.primary;
      return null; //EasyColors.secondary;
    }),
  ),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  accentColor: EasyColors.secondary,
  accentColorBrightness: Brightness.dark,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: EasyColors.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 0.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
    margin: const EdgeInsets.symmetric(vertical: 4.0),
  ),
  bottomNavigationBarTheme:
      BottomNavigationBarThemeData(selectedItemColor: EasyColors.primary),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) return EasyColors.secondary;
      return null; //EasyColors.secondary;
    }),
  ),
);

final ThemeData lightThemeDesktop = lightTheme.copyWith(
  cardTheme: CardTheme(
    elevation: 4.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating),
);

final ThemeData darkThemeDesktop = darkTheme.copyWith(
  cardTheme: CardTheme(
    elevation: 4.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating),
);
