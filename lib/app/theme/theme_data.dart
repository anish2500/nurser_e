import 'package:flutter/material.dart';
import 'package:nurser_e/app/theme/bottom_navigation_theme.dart';
import 'package:nurser_e/app/theme/input_decoration_theme.dart';

ThemeData getApplicationTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 240, 240, 240),
  );
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    fontFamily: 'Poppins Regular',

    inputDecorationTheme: getInputDecorationTheme(),
    bottomNavigationBarTheme: getBottomNavigationTheme(),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 3.0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,

        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(50),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
    ),
  );
}
