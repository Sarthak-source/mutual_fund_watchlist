import 'package:flutter/material.dart';

import 'app_colors.dart';

/// App text styles used throughout the application
class AppStyles {
  // Font Family
  static const String fontFamily = 'Roboto';
  
  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  
  // Heading Styles
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.25,
  );
  
  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
  );
  
  // Body Text Styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: regular,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: regular,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: regular,
    color: AppColors.textPrimary,
  );
  
  // Special Styles
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: regular,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: medium,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );
  
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: medium,
    color: AppColors.textPrimary,
  );
  
  // Helper method to change text color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
} 