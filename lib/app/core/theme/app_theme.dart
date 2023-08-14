import 'package:flutter/material.dart';

var outlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    side: const BorderSide(width: 1.5, color: Colors.orange),
    textStyle: const TextStyle(color: Colors.black),
  ),
);

final ThemeData themeData = ThemeData(
  primarySwatch: Colors.orange,
  scaffoldBackgroundColor: Colors.white,
  outlinedButtonTheme: outlinedButtonTheme,
  useMaterial3: true,
  fontFamily: 'RobotoMono',
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.orange,
    centerTitle: true,
  ),
);
