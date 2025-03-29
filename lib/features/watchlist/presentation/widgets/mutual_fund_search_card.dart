import 'package:flutter/material.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/mutual_fund_entity.dart';

class MutualFundSearchCard extends StatelessWidget {
  final MutualFundEntity fund;
  final bool isSelected;
  final VoidCallback onToggle;

  const MutualFundSearchCard({
    super.key,
    required this.fund,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.4),
              width: 0.4,
            ),
          ),
        ),
        child: Row(
          children: [
            // Fund logo/icon placeholder
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  fund.name.substring(0, 1),
                  style: AppStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: AppStyles.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Fund details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fund.name,
                    style: AppStyles.bodyMedium.copyWith(
                      fontWeight: AppStyles.medium,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fund.category,
                    style: AppStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Bookmark icon
            IconButton(
              onPressed: onToggle,
              icon: Icon(
                isSelected ? Icons.bookmark : Icons.bookmark_outline,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 