// This file can be deleted as we've replaced phone OTP verification 
// with email/password authentication through Supabase.
// Use the login_page.dart and register_page.dart files instead. 

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/cubit/auth_cubit.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/cubit/auth_state.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/theme/auth_theme.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/widgets/auth_widgets.dart';

class SignInOtpScreen extends StatefulWidget {
  final String phoneNumber;
  
  const SignInOtpScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<SignInOtpScreen> createState() => _SignInOtpScreenState();
}

class _SignInOtpScreenState extends State<SignInOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  @override
  void dispose() {
    _otpController.dispose();
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AuthTheme.screenPadding,
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.authenticated) {
                context.goNamed('home');
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'Welcome Back,',
                    style: AppStyles.h2,
                  ),
                  Row(
                    children: [
                      Text(
                        'We Missed You! ',
                        style: AppStyles.h2,
                      ),
                      const Icon(
                        Icons.celebration,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Glad to have you back at ',
                        style: AppStyles.bodySmall,
                      ),
                      Text(
                        'Dhan Saarthi',
                        style: AppStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Enter OTP',
                    style: AppStyles.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (index) => SizedBox(
                        width: 40,
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: AppStyles.h3,
                          decoration: InputDecoration(
                            counterText: '',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.divider,
                                width: 2,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              _focusNodes[index + 1].requestFocus();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Didn't Receive OTP? ",
                        style: AppStyles.bodySmall,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Resend OTP logic
                          context.read<AuthCubit>().requestOTP(
                                phoneNumber: widget.phoneNumber,
                              );
                        },
                        child: Text(
                          'Resend',
                          style: AppStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'OTP has been sent on ${widget.phoneNumber.substring(0, 4)}****${widget.phoneNumber.substring(widget.phoneNumber.length - 3)}',
                    style: AppStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  AuthButton(
                    text: 'Proceed',
                    onPressed: () {
                      final otp = _otpControllers
                          .map((controller) => controller.text)
                          .join();

                      if (otp.length == 6) {
                        context.read<AuthCubit>().verifyOTP(
                              phoneNumber: widget.phoneNumber,
                              otpCode: otp,
                            );
                      }
                    },
                    isLoading: state.status == AuthStatus.loading,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: AppStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          const TextSpan(
                            text: 'By signing in, you agree to our ',
                          ),
                          TextSpan(
                            text: 'T&C',
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                          const TextSpan(
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
              );
            },
          ),
        ),
      ),
    );
  }
} 