import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_styles.dart';

/// App theme configuration
class AppTheme {
  /// Get the light theme for the app
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppStyles.h4,
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppStyles.h1,
        displayMedium: AppStyles.h2, 
        displaySmall: AppStyles.h3,
        headlineMedium: AppStyles.h4,
        bodyLarge: AppStyles.bodyLarge,
        bodyMedium: AppStyles.bodyMedium,
        bodySmall: AppStyles.bodySmall,
        labelLarge: AppStyles.button,
        labelMedium: AppStyles.label,
        labelSmall: AppStyles.caption,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: AppStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppStyles.button,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.grey[100],
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  /// Get the dark theme for the app
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppStyles.h4,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppStyles.h1,
        displayMedium: AppStyles.h2, 
        displaySmall: AppStyles.h3,
        headlineMedium: AppStyles.h4,
        bodyLarge: AppStyles.bodyLarge,
        bodyMedium: AppStyles.bodyMedium,
        bodySmall: AppStyles.bodySmall,
        labelLarge: AppStyles.button,
        labelMedium: AppStyles.label,
        labelSmall: AppStyles.caption,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: AppStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppStyles.button,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.surfaceLight,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
} 