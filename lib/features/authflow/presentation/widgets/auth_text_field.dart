import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/theme/auth_theme.dart';

/// A reusable text field for authentication screens
class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final String? errorText;

  const AuthTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.inputFormatters,
    this.maxLength,
    this.focusNode,
    this.onChanged,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: AppStyles.bodyMedium,
      decoration: AuthTheme.inputDecoration.copyWith(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
      ),
      validator: validator,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      focusNode: focusNode,
      onChanged: onChanged,
    );
  }
} 