import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';
import 'package:mutual_fund_watchlist/core/utils/constants.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/cubit/auth_cubit.dart';
import 'package:mutual_fund_watchlist/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:mutual_fund_watchlist/features/onboarding/presentation/cubit/onboarding_state.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar:  AppBar(
        centerTitle: false,
        title: const Text('Dashboard', style: AppStyles.h4),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: AppColors.textPrimary,
            onPressed: () {
              context.read<AuthCubit>().signOut();
              context.go('/');
            },
          ),
        ],
      ),
      
      
      body: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          return const Padding(
            padding: EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to ${AppConstants.appName}',
                  style: AppStyles.h3,
                ),
                SizedBox(height: AppConstants.paddingMedium),
                Text(
                  'Your one-stop solution for mutual fund investments',
                  style: AppStyles.bodyMedium,
                ),
                SizedBox(height: AppConstants.paddingLarge),
                //_buildDashboardCards(),
              ],
            ),
          );
        },
      ),
    );
  }
} 

