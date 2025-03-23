import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/theme/auth_theme.dart';

/// A specialized text field for OTP input
class AuthOtpField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final int length;

  const AuthOtpField({
    Key? key,
    required this.controller,
    this.onChanged,
    this.length = 6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: AppStyles.bodyMedium,
      textAlign: TextAlign.center,
      inputFormatters: [
        LengthLimitingTextInputFormatter(length),
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: onChanged,
      decoration: AuthTheme.inputDecoration.copyWith(
        hintText: 'Enter OTP',
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
        counterText: '',
      ),
    );
  }
} 