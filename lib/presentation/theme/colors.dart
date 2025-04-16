import 'package:flutter/material.dart';

class AppColorScheme {
  static ColorScheme light() => ColorScheme.light(
    primary: _Colors.primary,
    primaryContainer: _Colors.primary.shade300,
    secondary: Colors.black,
    secondaryContainer: _Colors.secondary,
    onPrimary: Colors.white,
    onPrimaryContainer: Colors.white,
    surface: Colors.white,
    surfaceContainer: Color(0xFFF2F2F2),
    surfaceContainerHigh: Color(0xFFF2F2F2),
    surfaceContainerHighest: Color(0xFFE5E5E5),
    shadow: const Color(0xFFC3C3C3),
    tertiary: Colors.grey.shade700,
  );
}

class _Colors {
  static const MaterialColor primary = MaterialColor(0xFF898971, {
    50: Color(0xFFc4c4b8),
    100: Color(0xFFb8b8aa),
    200: Color(0xFFacac9c),
    300: Color(0xFFa1a18d),
    400: Color(0xFF95957f),
    500: Color(0xFF898971),
    600: Color(0xFF6e6e5a),
    700: Color(0xFF525244),
    800: Color(0xFF37372d),
    900: Color(0xFF1b1b17),
  });

  static const MaterialColor secondary = MaterialColor(0xFF59403B, {
    50: Color(0xFFaca09d),
    100: Color(0xFF9b8c89),
    200: Color(0xFF8b7976),
    300: Color(0xFF7a6662),
    400: Color(0xFF6a534f),
    500: Color(0xFF59403B),
    600: Color(0xFF47332f),
    700: Color(0xFF352623),
    800: Color(0xFF241a18),
    900: Color(0xFF120d0c),
  });
}
