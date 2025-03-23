import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';

/// Example of a widget matching the provided design screenshot.
/// Replace `AppColors` and `AppStyles` with your own theme classes/values.
class FundReturnsWidget extends StatefulWidget {
  const FundReturnsWidget({super.key});

  @override
  State<FundReturnsWidget> createState() => _FundReturnsWidgetState();
}

class _FundReturnsWidgetState extends State<FundReturnsWidget> {
  double _investedAmount = 1.0; // 1L to 10L

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: "If you invested ₹1L" + toggle (1-Time / Monthly SIP)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'If you invested ₹${_investedAmount.toStringAsFixed(0)}L',
                style: AppStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              // Toggle Buttons for "1-Time" and "Monthly SIP"
              Row(
                children: [
                  // 1-Time
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary, 
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '1-Time',
                      style: AppStyles.bodySmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Monthly SIP
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Monthly SIP',
                      style: AppStyles.bodySmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Slider from 1L to 10L
          Slider(
            value: _investedAmount,
            min: 1,
            max: 10,
            divisions: 9,
            label: '₹${_investedAmount.toStringAsFixed(0)}L',
            activeColor: AppColors.primary,
            inactiveColor: AppColors.border,
            onChanged: (double value) {
              setState(() {
                _investedAmount = value;
              });
            },
          ),

          const SizedBox(height: 8),

          // "If you invested ₹1L in this fund, your current value would be"
          // In your screenshot, this line is present. Adjust as needed:
          
          const SizedBox(height: 8),
          

          // "This Fund's past returns" + "Profit % (Absolute Return)"
          // plus the large green figure on the right (₹3.6L, 355.3%)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This Fund\'s past returns',
                    style: AppStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Profit % (Absolute Return)',
                    style: AppStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹3.6 L',
                    style: AppStyles.h2.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '355.3%',
                    style: AppStyles.bodySmall.copyWith(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // The 3-bar chart: Saving A/C, Category Avg., Direct Plan
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                minY: 0,
                maxY: 5, // a bit above the largest bar (4.55)
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.divider,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        switch (value.toInt()) {
                          case 0:
                            return Text(
                              'Saving A/C',
                              style: AppStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            );
                          case 1:
                            return Text(
                              'Category Avg.',
                              style: AppStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            );
                          case 2:
                            return Text(
                              'Direct Plan',
                              style: AppStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            );
                          default:
                            return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
                barGroups: [
                  // 1) Saving A/C => ~1.19
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: 1.19,
                        color: Colors.green,
                        width: 22,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
                  // 2) Category Avg => ~3.63
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: 3.63,
                        color: Colors.green,
                        width: 22,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
                  // 3) Direct Plan => ~4.55
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: 4.55,
                        color: Colors.green,
                        width: 22,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
