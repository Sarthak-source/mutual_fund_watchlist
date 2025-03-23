import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';
import 'package:mutual_fund_watchlist/core/utils/constants.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/cubit/auth_cubit.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/cubit/auth_state.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/theme/auth_theme.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/widgets/auth_widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _phoneController = TextEditingController();
  String? _phoneError;
  bool _isDevelopmentMode = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // Function to validate the phone number format
  bool _validatePhoneNumber(String phone) {
    // If in development mode, skip validation
    if (_isDevelopmentMode) {
      setState(() {
        _phoneError = null;
      });
      return true;
    }

    // Ensure the phone number starts with +
    if (!phone.startsWith('+')) {
      setState(() {
        _phoneError = 'Phone number must start with country code (+)';
      });
      return false;
    }

    // Basic E.164 format validation
    // This regex checks for + followed by 7-15 digits
    final validPhonePattern = RegExp(r'^\+[1-9]\d{7,14}$');
    if (!validPhonePattern.hasMatch(phone)) {
      setState(() {
        _phoneError = 'Enter a valid phone number with country code';
      });
      return false;
    }

    setState(() {
      _phoneError = null;
    });
    return true;
  }

  // Format the phone number correctly
  String _formatPhoneNumber(String phone) {
    // Remove any spaces or special characters except +
    return phone.replaceAll(RegExp(r'[^\+\d]'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sign In', style: AppStyles.h4),
        backgroundColor: Colors.transparent,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            // Navigate to Home screen directly
            context.goNamed('home');
          } else if (state.status == AuthStatus.otpSent) {
            // Navigate to OTP verification screen
            context.goNamed('otp', extra: state.phoneNumber);
          } else if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication error'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: AuthTheme.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter your phone number',
                  style: AppStyles.bodyLarge,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                AuthTextField(
                  controller: _phoneController,
                  hintText: '+91XXXXXXXXXX',
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone, color: AppColors.textSecondary),
                  errorText: _phoneError,
                ),
                const SizedBox(height: 8),
                Text(
                  'Format: +[country code][number] (e.g. +14155552671)',
                  style: AppStyles.withColor(
                    AppStyles.bodySmall, 
                    AppColors.textSecondary,
                  ),
                ),
                // Development mode toggle
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isDevelopmentMode,
                        onChanged: (value) {
                          setState(() {
                            _isDevelopmentMode = value ?? false;
                          });
                        },
                      ),
                      Text(
                        'Developer Mode (Skip OTP)',
                        style: AppStyles.withColor(
                          AppStyles.bodySmall,
                          AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                AuthButton(
                  text: 'Continue',
                  onPressed: () {
                    log('Continue pressed');
                    
                    // Development mode bypass
                    if (_isDevelopmentMode) {
                      // Skip OTP and go directly to home screen for testing
                      context.goNamed('home');
                      return;
                    }
                    
                    // Format and validate the phone number
                    final rawPhone = _phoneController.text.trim();
                    final phone = _formatPhoneNumber(rawPhone);
                    
                    if (phone.isNotEmpty && _validatePhoneNumber(phone)) {
                      // Request OTP from the backend
                      context.read<AuthCubit>().requestOTP(phoneNumber: phone);
                    }
                  },
                  isLoading: state.status == AuthStatus.loading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 