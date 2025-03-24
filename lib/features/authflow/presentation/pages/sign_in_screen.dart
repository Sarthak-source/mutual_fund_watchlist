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

  // Validate phone number format
  bool _validatePhoneNumber(String phone) {
    if (_isDevelopmentMode) {
      setState(() => _phoneError = null);
      return true;
    }
    if (!phone.startsWith('+')) {
      setState(() => _phoneError = 'Phone number must start with country code (+)');
      return false;
    }
    final validPhonePattern = RegExp(r'^\+[1-9]\d{7,14}$');
    if (!validPhonePattern.hasMatch(phone)) {
      setState(() => _phoneError = 'Enter a valid phone number with country code');
      return false;
    }
    setState(() => _phoneError = null);
    return true;
  }

  // Remove any non-digit (except '+') characters
  String _formatPhoneNumber(String phone) {
  // Remove any characters that are not '+' or digits.
  final formatted = phone.replaceAll(RegExp(r'[^\+\d]'), '');
  // If the formatted phone doesn't start with '+91', prepend it.
  if (!formatted.startsWith('+91')) {
    return '+91$formatted';
  }
  return formatted;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar:  AppBar(
        centerTitle: false,
       
        //title: const Text('Sign In', style: AppStyles.h4),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.goNamed('home');
          } else if (state.status == AuthStatus.otpSent) {
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
          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: AuthTheme.screenPadding,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header Title
                          const Text(
                            'Welcome Back, \nWe Missed You! 🎉',
                            style: AppStyles.h2,
                          ),
                          const SizedBox(height: 8),
                          // Sub-text with highlighted user name
                          RichText(
                            text: TextSpan(
                              text: 'Glad to have you back at ',
                              style: AppStyles.bodyLarge.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Dhan Saorathi',
                                  style: AppStyles.bodyLarge.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 54),
                          // Phone Number Label
                          const Text(
                            'Enter your phone number',
                            style: AppStyles.bodySmall,
                          ),
                          const SizedBox(height: AppConstants.paddingMedium),
                          // Phone Input Field
                          AuthTextField(
                            controller: _phoneController,
                            hintText: '+91XXXXXXXXXX',
                            keyboardType: TextInputType.phone,
                            prefixIcon: const Icon(Icons.phone, color: AppColors.textSecondary),
                            errorText: _phoneError,
                          ),
                          const SizedBox(height: 8),
                          // Text(
                          //   'Format: +[country code][number] (e.g. +14155552671)',
                          //   style: AppStyles.withColor(
                          //     AppStyles.bodySmall,
                          //     AppColors.textSecondary,
                          //   ),
                          // ),
                          // Developer Mode Toggle
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _isDevelopmentMode,
                                  onChanged: (value) {
                                    setState(() => _isDevelopmentMode = value ?? false);
                                  },
                                  activeColor: AppColors.primary,
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
                          // Spacer alternative: Expanded widget to push button to bottom
                          //Expanded(child: Container()),
                          // Proceed Button with bottom padding
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24.0,right: 18,left: 18),
                            child: AuthButton(
                              text: 'Proceed',
                              onPressed: () {
                                log('Proceed pressed');
                                if (_isDevelopmentMode) {
                                  context.goNamed('home');
                                  return;
                                }
                                final rawPhone = _phoneController.text.trim();
                                final phone = _formatPhoneNumber(rawPhone);
                                if (phone.isNotEmpty && _validatePhoneNumber(phone)) {
                                  context.read<AuthCubit>().requestOTP(phoneNumber: phone);
                                }
                              },
                              isLoading: state.status == AuthStatus.loading,
                              // If AuthButton supports a custom color, specify it here.
                              // color: AppColors.primary,
                            ),
                          ),

                          Expanded(child: Container()),

                          Center(
                    child: RichText(
                      text: TextSpan(
                        style: AppStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        children: const [
                          TextSpan(
                            text: 'By signing in, you agree to our ',
                          ),
                          TextSpan(
                            text: 'T&C',
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                          TextSpan(
                            text: ' and ',
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
