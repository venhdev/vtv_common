import 'package:flutter/material.dart';

class VTVTheme {
  //# Light Theme
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          background: Color(0xFFFFFDF5),
          primary: Colors.black87,
          primaryContainer: Color(0xFFFFC600),
        ),
        buttonTheme: const ButtonThemeData(
          colorScheme: ColorScheme.light(
            primaryContainer: Color(0xFFFFC600),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF0DF9E),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      );

  //# Dark Theme
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      );

  //# Custom Style

  // hint text style
  static TextStyle get hintTextStyle => const TextStyle(
        color: Colors.grey,
        fontSize: 12,
      );

  static TextStyle get hintTextMediumStyle => const TextStyle(
        color: Colors.grey,
        fontSize: 13,
      );
}
