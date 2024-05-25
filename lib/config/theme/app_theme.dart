import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() {
    return ThemeData(
        colorSchemeSeed: Colors.amber,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
        ));
  }
}
