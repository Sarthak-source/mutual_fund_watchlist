import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';
import 'package:mutual_fund_watchlist/features/chart/presentation/pages/chart_page.dart';
import 'package:mutual_fund_watchlist/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:mutual_fund_watchlist/features/onboarding/presentation/cubit/onboarding_state.dart';
import 'package:mutual_fund_watchlist/features/onboarding/presentation/pages/Home_dashboard_screen.dart';
import 'package:mutual_fund_watchlist/features/onboarding/presentation/widgets/bottom_nav_bar.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/pages/watchlist_page.dart';

/// Home screen with dashboard functionality after user authentication
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        // Get the current page based on selected tab index
        Widget currentPage;
        switch (state.selectedTabIndex) {
          case 0:
            currentPage = const HomeDashboardScreen();
            break;
          case 1:
            // Wrap ChartPage with a scaffold that has an AppBar with back button
            currentPage = Scaffold(
              appBar: AppBar(
                centerTitle: false,
                backgroundColor: AppColors.background,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    // Navigate back to home by setting tab index to 0
                    context.read<OnboardingCubit>().changeTab(0);
                  },
                ),
                title: Text(
                  'Chart',
                  style: AppStyles.h4.copyWith(color: Colors.white),
                ),
              ),
              body: const ChartPage(),
            );
            break;
          case 2:
            // Wrap WatchlistPage with a scaffold that has an AppBar with back button
            currentPage = Scaffold(
              appBar: AppBar(
                centerTitle: false,
                backgroundColor: AppColors.background,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    // Navigate back to home by setting tab index to 0
                    context.read<OnboardingCubit>().changeTab(0);
                  },
                ),
                title: Text(
                  'Watchlist',
                  style: AppStyles.h4.copyWith(color: Colors.white),
                ),
              ),
              body: const WatchlistPage(),
            );
            break;
          default:
            currentPage = const HomeDashboardScreen();
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          // Only show bottom navigation bar on HomeDashboardScreen (index 0)
          bottomNavigationBar: state.selectedTabIndex == 0 
              ? BottomNavBar(
                  currentIndex: state.selectedTabIndex,
                  onTap: (index) {
                    context.read<OnboardingCubit>().changeTab(index);
                  },
                )
              : null,
          body: currentPage,
        );
      },
    );
  }
}


