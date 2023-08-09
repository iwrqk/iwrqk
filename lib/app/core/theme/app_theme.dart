import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData get lightTheme {
    Color primaryColor = const Color.fromARGB(255, 24, 170, 141);

    return ThemeData.light().copyWith(
      appBarTheme: const AppBarTheme(
        color: CupertinoColors.white,
        foregroundColor: Colors.black,
        shadowColor: Colors.transparent,
      ),
      primaryColor: primaryColor,
      primaryColorLight: primaryColor,
      tabBarTheme: const TabBarTheme().copyWith(
        labelColor: primaryColor,
        indicatorColor: primaryColor,
        unselectedLabelColor: Colors.grey,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          splashFactory: NoSplash.splashFactory,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          splashFactory: NoSplash.splashFactory,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme().copyWith(
        prefixIconColor: primaryColor,
        suffixIconColor: primaryColor,
        focusColor: primaryColor,
        floatingLabelStyle: TextStyle(
          color: primaryColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(7.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(7.5),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: CupertinoColors.white,
        foregroundColor: Colors.grey,
      ),
      popupMenuTheme: const PopupMenuThemeData().copyWith(
        color: CupertinoColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 15,
        ),
      ),
      scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
      indicatorColor: Colors.grey,
      cardColor: CupertinoColors.systemGroupedBackground,
      canvasColor: CupertinoColors.white,
      shadowColor: Colors.grey,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }

  static ThemeData get darkTheme {
    Color primaryColor = Colors.blue;

    return ThemeData.dark().copyWith(
      appBarTheme: const AppBarTheme(
        color: Color.fromARGB(255, 40, 44, 52),
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData().copyWith(
        backgroundColor: const Color.fromARGB(255, 40, 44, 52),
      ),
      primaryColor: primaryColor,
      primaryColorLight: primaryColor,
      tabBarTheme: const TabBarTheme().copyWith(
        labelColor: primaryColor,
        indicatorColor: primaryColor,
        unselectedLabelColor: Colors.grey,
      ),
      inputDecorationTheme: const InputDecorationTheme().copyWith(
        prefixIconColor: primaryColor,
        suffixIconColor: primaryColor,
        focusColor: primaryColor,
        floatingLabelStyle: TextStyle(
          color: primaryColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(7.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(7.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          splashFactory: NoSplash.splashFactory,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          splashFactory: NoSplash.splashFactory,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color.fromARGB(255, 36, 39, 46),
        foregroundColor: Colors.grey,
      ),
      popupMenuTheme: const PopupMenuThemeData().copyWith(
        color: const Color.fromARGB(255, 36, 39, 46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 15,
        ),
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 31, 34, 40),
      cardColor: const Color.fromARGB(255, 36, 39, 46),
      indicatorColor: Colors.white,
      canvasColor: const Color.fromARGB(255, 40, 44, 52),
      shadowColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}
