import 'package:flutter/material.dart';

const PrimaryColor = Color(0xFF3E4067);
const TextColor = Color(0xFF757575);

ThemeData themeData([int index = 0]) {
  switch (index) {
    case 0:
      return ThemeData(
        primaryColor: PrimaryColor,
        primaryColorLight: const Color(0xFF3E5067),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: appBarThemeData(),
        textButtonTheme: textButtonThemeData(),
        textTheme: textThemeData(),
        inputDecorationTheme: inputDecorationThemeData(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );
    // break;

    case 1:
      return ThemeData(
        // fontFamily: 'Poppins',
        primaryColor: Colors.white,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        accentColor: Colors.redAccent,
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 22.0,
            color: Colors.redAccent,
          ),
          headline2: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            color: Colors.redAccent,
          ),
          bodyText1: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Colors.blueAccent,
          ),
        ),
      );
    // break;

    default:
      return ThemeData(
        primarySwatch: Colors.blue,
      );
  }
}

InputDecorationTheme inputDecorationThemeData() {
  final outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: const BorderSide(color: TextColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

TextButtonThemeData textButtonThemeData() {
  return TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: PrimaryColor, //Theme.of(context).primaryColor,
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      // padding: const EdgeInsets.all(16.0),
      // textStyle: const TextStyle(fontSize: 20),
    ),
  );
}

TextTheme textThemeData() {
  return const TextTheme(
    bodyText1: TextStyle(color: TextColor),
    bodyText2: TextStyle(color: TextColor),
  );
}

AppBarTheme appBarThemeData() {
  return const AppBarTheme(
    color: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    textTheme: TextTheme(
      headline6: TextStyle(color: Color(0xff8b8b8b), fontSize: 18),
    ),
  );
}
