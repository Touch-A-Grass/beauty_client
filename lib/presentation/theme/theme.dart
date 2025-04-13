import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class AppTheme {
  static ThemeData theme(ColorScheme colorScheme) => ThemeData(
    textTheme: GoogleFonts.robotoTextTheme(),
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    appBarTheme: _appBarTheme(colorScheme),
    dividerTheme: DividerThemeData(color: colorScheme.shadow, indent: 32, endIndent: 32),
    tabBarTheme: TabBarThemeData(dividerColor: Colors.transparent),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    ),
  );

  static _appBarTheme(ColorScheme colorScheme) => AppBarTheme(
    backgroundColor: colorScheme.surface,
    shadowColor: colorScheme.shadow,
    scrolledUnderElevation: 1,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    actionsPadding: const EdgeInsets.only(right: 16),
  );
}
