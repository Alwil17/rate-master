import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBackground = Color(0xFFFFFFFF);
  static const Color secondaryBackground = Color(0xFFFFE5FD);
  static const Color primaryText = Color(0xFFF5F5F5);
  static const Color accent = Color(0xFFFABE17);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color secondaryAccent = Color(0xFF7E57C2);
  static const Color vectorsBackground = Color(0xFFFFE5FD);
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: AppColors.accent,
    width: 1,
  ),
);

const errorInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: AppColors.error,
    width: 1,
  ),
);

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
  inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      errorStyle: TextStyle(height: 0),
      border: defaultInputBorder,
      enabledBorder: defaultInputBorder,
      focusedBorder: defaultInputBorder,
      errorBorder: errorInputBorder,
      labelStyle: TextStyle(color: Color(0xff3A3A3B), fontSize: 13),
      hintStyle: TextStyle(color: Colors.grey)),
);
