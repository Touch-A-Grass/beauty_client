import 'package:flutter/material.dart';

extension SnackbarExtension on BuildContext {
  void showErrorSnackBar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(text)));
  }
}
