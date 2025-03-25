import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';

/// Example of a widget matching the provided design screenshot.
/// Replace `AppColors` and `AppStyles` with your own theme classes/values.
class FundReturnsWidget extends StatefulWidget {
  const FundReturnsWidget({Key? key}) : super(key: key);

  @override
  State<FundReturnsWidget> createState() => _FundReturnsWidgetState();
}

class _FundReturnsWidgetState extends State<FundReturnsWidget> {
  double _investedAmount = 1.0; // Represents 1L to 10L

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
          // Top row: "If you invested ₹1L" and toggle buttons for "1-Time" and "Monthly SIP"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'If you invested ₹${_investedAmount.toStringAsFixed(0)}L',
                style: AppStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const CustomToggleButtonInline(),
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
          // Additional text can be inserted here if needed
          //const SizedBox(height: 8),
          // Row displaying fund return info and profit percentage
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
          // 3-bar chart: Saving A/C, Category Avg., Direct Plan
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                minY: 0,
                maxY: 5, // a bit above the largest bar (4.55)
                // Remove all grid lines by disabling the grid
                gridData: const FlGridData(show: false),
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
                  // Bar for Saving A/C (approx. 1.19)
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: 1.19,
                        color: Colors.green,
                        width: 50,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
                  // Bar for Category Avg. (approx. 3.63)
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: 3.63,
                        color: Colors.green,
                        width: 50,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
                  // Bar for Direct Plan (approx. 4.55)
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: 4.55,
                        color: Colors.green,
                        width: 50,
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



class CustomToggleButtonInline extends StatefulWidget {
  const CustomToggleButtonInline({super.key});

  @override
  CustomToggleButtonInlineState createState() => CustomToggleButtonInlineState();
}

class CustomToggleButtonInlineState extends State<CustomToggleButtonInline> {
  double xAlign = -1; // left selected by default

  @override
  Widget build(BuildContext context) {
    const double toggleWidth = 120.0;
    const double toggleHeight = 30.0;
    const double halfWidth = toggleWidth / 2;

    return Container(
      width: toggleWidth,
      height: toggleHeight,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: Colors.grey,width: 0.4), // White border for the whole button
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: Alignment(xAlign, 0),
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: halfWidth,
                height: toggleHeight,
                color: AppColors.primary, // Primary color for active selection
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  xAlign = -1;
                });
              },
              child: Align(
                alignment: const Alignment(-1, 0),
                child: Container(
                  width: halfWidth,
                  height: toggleHeight,
                  alignment: Alignment.center,
                  child: Text(
                    '1-Time',
                    style: AppStyles.bodySmall.copyWith(color: Colors.white,fontSize: 10), // Unselected text color white
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  xAlign = 1;
                });
              },
              child: Align(
                alignment: const Alignment(1, 0),
                child: Container(
                  width: halfWidth,
                  height: toggleHeight,
                  alignment: Alignment.center,
                  child: Text(
                    'Monthly SIP',
                    style: AppStyles.bodySmall.copyWith(color: Colors.white,fontSize: 10), // Unselected text color white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
