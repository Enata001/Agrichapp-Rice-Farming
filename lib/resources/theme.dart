import 'package:agrichapp/resources/app_colours.dart';
import 'package:flutter/material.dart';

final theme = ThemeData(
  primaryColor: AppColors.forestGreen,
  primaryColorLight: AppColors.clearGreen,
  canvasColor: Colors.deepPurpleAccent,
  fontFamily: 'poppins',
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.forestGreen,
      maximumSize: const Size(220, 60),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    ),
  ),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.white,
      size: 28,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.all(8),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      borderSide: BorderSide(
        width: 2,
        color: AppColors.clearGreen,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      borderSide: BorderSide(
        width: 2,
        color: AppColors.forestGreen,
      ),
    ),
    floatingLabelStyle: TextStyle(
      fontSize: 15,
      color: AppColors.forestGreen,
    ),
    labelStyle: TextStyle(
      fontSize: 14,
      color: AppColors.forestGreen,
    ),
  ),
  useMaterial3: true,
  textTheme: const TextTheme(
    titleMedium: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: AppColors.forestGreen,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: AppColors.forestGreen,
    ),
    titleLarge: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 30,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 20,
      color: Colors.white,
    ),
    labelMedium: TextStyle(
      fontSize: 20,
      color: AppColors.forestGreen,
    ),
  ),
);
