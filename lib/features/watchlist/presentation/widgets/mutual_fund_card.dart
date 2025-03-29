import 'package:flutter/material.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/mutual_fund_entity.dart';

class MutualFundCard extends StatelessWidget {
  final MutualFundEntity fund;
  final VoidCallback? onDelete;

  const MutualFundCard({
    super.key,
    required this.fund,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(fund.isin),
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final bool? result = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content: Text('Are you sure you want to delete ${fund.name}?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
        if (result == true && onDelete != null) {
          onDelete!();
        }
        return result ?? false;
      },
      onDismissed: (direction) {
        // The onDelete callback is now handled in confirmDismiss
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 0.2,
          ),
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.55,
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
                        Text(
                          'Others | ${fund.category}',
                          style: AppStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'NAV ₹${fund.nav}',
                        style: AppStyles.bodyMedium.copyWith(
                          fontWeight: AppStyles.medium,
                        ),
                      ),
                      Text(
                        '1D ${fund.changePercent >= 0 ? '+' : ''}${fund.changePercent.toStringAsFixed(2)}%',
                        style: AppStyles.bodySmall.copyWith(
                          color: fund.changePercent >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(color: Colors.grey, thickness: 0.4),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildReturnColumn('1Y', fund.oneYearReturn),
                  _buildReturnColumn('3Y', fund.threeYearReturn),
                  _buildReturnColumn('5Y', fund.fiveYearReturn),
                  _buildExpenseRatio(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReturnColumn(String period, double returnValue) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          period,
          style: AppStyles.caption,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          '${returnValue.toStringAsFixed(2)}%',
          style: AppStyles.bodySmall.copyWith(
            color: returnValue >= 0 ? Colors.green : Colors.red,
            fontWeight: AppStyles.medium,
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseRatio() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Exp. Ratio',
          style: AppStyles.caption,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          '25.50%',
          style: AppStyles.bodySmall.copyWith(
            fontWeight: AppStyles.medium,
          ),
        ),
      ],
    );
  }
}
