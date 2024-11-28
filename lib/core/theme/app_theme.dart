import 'package:flutter/material.dart';
import '../../common/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorSchemeSeed: AppColors.primaryYellow,
    scaffoldBackgroundColor: AppColors.background,
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
      bodyLarge: TextStyle(color: AppColors.black, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.grey, fontSize: 14),
      bodySmall: TextStyle(color: AppColors.lightGrey, fontSize: 12),
      headlineMedium: TextStyle(color: AppColors.lightGrey),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.primaryYellow,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryYellow,
      foregroundColor: AppColors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primaryYellow),
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
      hintStyle: const TextStyle(color: AppColors.lightGrey),
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
      backgroundColor: AppColors.darkYellow,
      foregroundColor: AppColors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.lightGrey),
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
      hintStyle: const TextStyle(color: AppColors.lightGrey),
    ),
  );
}
