import 'package:flutter/material.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';
import 'package:mutual_fund_watchlist/core/utils/constants.dart';

/// Auth theme helper with common styles for auth screens
class AuthTheme {
  // Text field decoration
  static InputDecoration get inputDecoration => InputDecoration(
    filled: true,
    fillColor: AppColors.surfaceLight,
    hintStyle: AppStyles.withColor(AppStyles.bodyMedium, AppColors.textSecondary),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppConstants.paddingMedium,
      vertical: AppConstants.paddingMedium,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      borderSide: const BorderSide(color: AppColors.primary, width: 1),
    ),
  );

  // Primary button style
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textPrimary,
    textStyle: AppStyles.button,
    padding: const EdgeInsets.symmetric(
      vertical: AppConstants.paddingMedium,
      horizontal: AppConstants.paddingLarge,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
    ),
    minimumSize: const Size(double.infinity, 35),
  );

  // Secondary button style
  static ButtonStyle get secondaryButtonStyle => TextButton.styleFrom(
    foregroundColor: AppColors.primary,
    textStyle: AppStyles.button,
    padding: const EdgeInsets.symmetric(
      vertical: AppConstants.paddingMedium,
    ),
  );

  // Circle button style
  static ButtonStyle get circleButtonStyle => ElevatedButton.styleFrom(
    shape: const CircleBorder(),
    padding: const EdgeInsets.all(AppConstants.paddingMedium),
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textPrimary,
  );

  // Screen padding
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: AppConstants.paddingLarge,
    vertical: AppConstants.paddingMedium,
  );
} 