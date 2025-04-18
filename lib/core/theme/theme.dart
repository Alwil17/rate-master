import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBackground = Color(0xFFFFE5FD);
  static const Color secondaryBackground = Color(0xFF2C3E50);
  static const Color primaryText = Color(0xFFF5F5F5);
  static const Color accent = Color(0xFFFABE17);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color secondaryAccent = Color(0xFF7E57C2);
}

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.primaryBackground,
  primaryColor: AppColors.accent,
  hintColor: AppColors.secondaryAccent,
  fontFamily: 'Roboto',
  textTheme: TextTheme(
    displayLarge: TextStyle(color: AppColors.secondaryBackground, fontSize: 32, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: AppColors.secondaryBackground, fontSize: 20),
    bodyLarge: TextStyle(color: AppColors.secondaryBackground, fontSize: 16),
    bodyMedium: TextStyle(color: AppColors.secondaryBackground, fontSize: 14),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: AppColors.accent,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  appBarTheme: AppBarTheme(
    color: AppColors.secondaryBackground,
    iconTheme: IconThemeData(color: AppColors.primaryText),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.accent,
    foregroundColor: AppColors.primaryText,
  ),
);
