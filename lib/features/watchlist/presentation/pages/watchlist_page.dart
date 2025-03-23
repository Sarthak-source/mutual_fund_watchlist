import 'package:flutter/material.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark,
              size: 64,
              color: AppColors.primary,
            ),
            SizedBox(height: 16),
            Text(
              'Watchlist',
              style: AppStyles.h3,
            ),
            SizedBox(height: 8),
            Text(
              'Track your favorite mutual funds',
              style: AppStyles.bodyMedium,
            ),
            SizedBox(height: 32),
            // Placeholder for future implementation
            Text('Your watchlist will appear here'),
          ],
        ),
      ),
    );
  }
}
