import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';

class EmptyWatchlist extends StatelessWidget {
  const EmptyWatchlist({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery here to keep widget responsiveness consistent with the rest of your app.
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SVG image for watchlist icon
          SizedBox(
            height: 80,
            width: MediaQuery.of(context).size.width,
            child: SvgPicture.asset(
              'assets/watch-list.svg',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
          // Main title text
          Text(
            'Looks like your watchlist is empty',
            style: AppStyles.bodyMedium.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Subtitle text
          Text(
            'Add mutual funds to your watchlist to track them',
            style: AppStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Outlined button styled with consistent colors and font
          OutlinedButton(
            onPressed: () {
              // TODO: Implement navigation to add funds screen
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: AppColors.textPrimary,
                width: 0.4,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: AppColors.textPrimary),
                const SizedBox(width: 8),
                Text(
                  'Add Mutual Funds',
                  style: AppStyles.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
