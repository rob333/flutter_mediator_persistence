import 'package:flutter/material.dart';

ThemeData themeData([int index = 0]) {
  final primary = Colors.blue;
  final primaryColor = Colors.blue.shade300;

  switch (index) {
    case 0: // dark theme
      return ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey.shade900,
        primaryColorDark: primaryColor,
        colorScheme: ColorScheme.dark(primary: primary),
        dividerColor: Colors.white,
      );
    // break;

    case 1:
      return ThemeData.light().copyWith(
        // fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        primaryColor: primaryColor,
        colorScheme: ColorScheme.light(primary: primary),
        dividerColor: Colors.black,
      );
    // break;

    default:
      return ThemeData(
        primarySwatch: Colors.blue,
      );
  }
}
