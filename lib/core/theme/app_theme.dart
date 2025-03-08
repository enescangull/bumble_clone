import 'package:flutter/material.dart';
import '../../common/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorSchemeSeed: AppColors.primaryYellow,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Urbanist',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.transparent,
      iconTheme: IconThemeData(color: AppColors.black),
      titleTextStyle: TextStyle(
        color: AppColors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.black, fontSize: 18),
      bodyMedium: TextStyle(color: AppColors.black, fontSize: 16),
      bodySmall: TextStyle(color: AppColors.lightGrey, fontSize: 12),
      headlineMedium: TextStyle(color: AppColors.lightGrey),
      headlineLarge: TextStyle(
          color: AppColors.black, fontSize: 32, fontWeight: FontWeight.w600),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.primaryYellow,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color.fromARGB(152, 255, 255, 255),
        foregroundColor: AppColors.primaryYellow,
        shape: CircleBorder(side: BorderSide.none)),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color.fromARGB(152, 255, 255, 255),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 0, strokeAlign: 0),
        borderRadius: BorderRadius.circular(30),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primaryYellow),
        borderRadius: BorderRadius.circular(30),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.errorRed),
        borderRadius: BorderRadius.circular(30),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.errorRed),
        borderRadius: BorderRadius.circular(30),
      ),
      hintStyle: const TextStyle(color: AppColors.primaryYellow),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkYellow,
    scaffoldBackgroundColor: AppColors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.transparent,
      iconTheme: IconThemeData(color: AppColors.white),
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.white, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.lightGrey, fontSize: 14),
      bodySmall: TextStyle(color: AppColors.grey, fontSize: 12),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.darkYellow,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(152, 0, 0, 0),
      foregroundColor: AppColors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color.fromARGB(152, 0, 0, 0),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.darkYellow),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.errorRed),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.errorRed),
        borderRadius: BorderRadius.circular(8),
      ),
      hintStyle: const TextStyle(color: AppColors.primaryYellow),
    ),
  );
}
