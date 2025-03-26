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
  double _investedAmount = 1.0; // Represents 1L to 10L
  bool _isOneTime = true; // Track investment mode

  // Calculate returns based on investment amount and mode
  double _calculateReturns(double amount, bool isOneTime) {
    final values = _getBarValues(amount, isOneTime);
    // Return the Direct Plan value (highest return)
    return values[2];
  }

  // Calculate profit percentage
  double _calculateProfitPercentage(double returns, double invested) {
    // Convert invested amount from Lakhs to the same unit as returns
    final investedAmount = invested * 1.0; // 1L = 1.0 units
    return ((returns - investedAmount) / investedAmount * 100).roundToDouble();
  }

  // Get bar values based on current investment
  List<double> _getBarValues(double amount, bool isOneTime) {
    // Base values when investment is 1L
    const baseValues = {
      'saving': 1.19,
      'category': 3.63,
      'direct': 4.55,
    };
    
    // Calculate the proportion of each value relative to the direct plan
    final directPlanRatio = baseValues['direct']!;
    final savingRatio = baseValues['saving']! / directPlanRatio;
    final categoryRatio = baseValues['category']! / directPlanRatio;
    
    // Calculate the direct plan value based on investment amount
    final directPlanValue = amount * (isOneTime ? 4.55 : 5.0);
    
    // Calculate other values maintaining their proportions
    return [
      directPlanValue * savingRatio,
      directPlanValue * categoryRatio,
      directPlanValue,
    ];
  }

  void _updateInvestmentMode(bool isOneTime) {
    setState(() {
      _isOneTime = isOneTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    final returns = _calculateReturns(_investedAmount, _isOneTime);
    final profitPercentage = _calculateProfitPercentage(returns, _investedAmount);
    final barValues = _getBarValues(_investedAmount, _isOneTime);

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
              Row(
                children: [
                  Text(
                    'If you invested ',
                    style: AppStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4,),
                  SizedBox(
                    width: 40,
                    height: 24,
                    child: Stack(
                      children: [
                        TextField(
                          controller: TextEditingController(text: '₹${_investedAmount.toStringAsFixed(0)}L'),
                          style: AppStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.only(bottom: 4),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.textSecondary.withOpacity(0.5),
                                width: 0.5,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.textSecondary.withOpacity(0.5),
                                width: 0.5,
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 0.5,
                              ),
                            ),
                            suffixIconConstraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                          ),
                          onChanged: (value) {
                            // Remove non-numeric characters
                            String numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                            if (numericValue.isNotEmpty) {
                              double newValue = double.parse(numericValue);
                              // Ensure value is within 1-10 range
                              newValue = newValue.clamp(1, 10);
                              setState(() {
                                _investedAmount = newValue;
                              });
                            }
                          },
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Icon(
                            Icons.edit,
                            size: 14,
                            color: AppColors.textSecondary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              CustomToggleButtonInline(
                isOneTime: _isOneTime,
                onToggle: _updateInvestmentMode,
              ),
            ],
          ),
          // Slider with labels
          Column(
            children: [
              Slider(
                value: _investedAmount,
                min: 1,
                max: 10,
                //divisions: 9,
                label: '₹${_investedAmount.toStringAsFixed(0)}L',
                activeColor: AppColors.primary,
                inactiveColor: AppColors.border,
                onChanged: (double value) {
                  setState(() {
                    _investedAmount = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹1L',
                      style: AppStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '₹10L',
                      style: AppStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Profit % (Absolute Return)',
                    style: AppStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${returns.toStringAsFixed(1)} L',
                    style: AppStyles.h2.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${profitPercentage.toStringAsFixed(1)}%',
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
                maxY: barValues[2] * 1.1, // Dynamic max based on highest bar
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
                  // Bar for Saving A/C
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: barValues[0],
                        color: Colors.green,
                        width: 50,
                        borderRadius: BorderRadius.circular(2),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: barValues[2],
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  ),
                  // Bar for Category Avg.
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: barValues[1],
                        color: Colors.green,
                        width: 50,
                        borderRadius: BorderRadius.circular(2),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: barValues[2],
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  ),
                  // Bar for Direct Plan
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: barValues[2],
                        color: Colors.green,
                        width: 50,
                        borderRadius: BorderRadius.circular(2),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: barValues[2],
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  ),
                ],
                barTouchData: BarTouchData(
                  enabled: false,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.transparent,
                    tooltipPadding: EdgeInsets.zero,
                    tooltipMargin: 0,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '₹${barValues[groupIndex].toStringAsFixed(2)}L',
                        AppStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomToggleButtonInline extends StatelessWidget {
  final bool isOneTime;
  final Function(bool) onToggle;

  const CustomToggleButtonInline({
    super.key,
    required this.isOneTime,
    required this.onToggle,
  });

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
        border: Border.all(color: Colors.grey, width: 0.4),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(isOneTime ? -1 : 1, 0),
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: halfWidth,
              height: toggleHeight - 2,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onToggle(true),
                  child: Center(
                    child: Text(
                      '1-Time',
                      style: AppStyles.bodySmall.copyWith(
                        color: isOneTime ? Colors.white : AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onToggle(false),
                  child: Center(
                    child: Text(
                      'Monthly SIP',
                      style: AppStyles.bodySmall.copyWith(
                        color: !isOneTime ? Colors.white : AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
