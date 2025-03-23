import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/theme/auth_theme.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/widgets/auth_widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // SafeArea to avoid overlapping with status bar on iOS/Android
      body: SafeArea(
        child: Padding(
          // Some horizontal padding to avoid text sticking to the edges
          padding: AuthTheme.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Spacer to push content towards center
              const Spacer(),
              // Logo
              Center(
                child: SizedBox(
                  height: 120,
                  width: 120,
                  child: Image.asset(
                    'assets/images/dhan_logo.png', // Replace with your logo asset
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // "Welcome to DhanSaarthi !" text
              Center(
                child: Text(
                  'Welcome to DhanSaarthi !',
                  style: AppStyles.h2,
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              // Bottom row with tagline on the left and circular arrow button on the right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "One step closer to smarter investing. Let's begin!",
                      style: AppStyles.withColor(AppStyles.bodySmall, AppColors.textSecondary),
                    ),
                  ),
                  AuthButton(
                    text: '',
                    type: ButtonType.circle,
                    icon: Icons.arrow_forward,
                    onPressed: () {
                      // Navigate to sign in
                      context.goNamed('signIn');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
