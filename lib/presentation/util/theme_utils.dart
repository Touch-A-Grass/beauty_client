import 'package:flutter/material.dart';

extension ThemeContextExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  bool get isMobile => MediaQuery.of(this).size.width < 600;
}
