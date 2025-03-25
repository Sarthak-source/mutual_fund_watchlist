import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';
import 'package:mutual_fund_watchlist/features/chart/presentation/widget/fund_return_cart.dart';
import 'package:mutual_fund_watchlist/features/chart/presentation/widget/time_range_chip.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  // Example data for the two lines
  final List<FlSpot> _yourInvestmentsData = [
    const FlSpot(0, 1.2),
    const FlSpot(1, 1.8),
    const FlSpot(2, 1.5),
    const FlSpot(3, 2.2),
    const FlSpot(4, 2.0),
    const FlSpot(5, 2.5),
    const FlSpot(6, 1.6),
  ];

  final List<FlSpot> _niftyMidcapData = [
    const FlSpot(0, 1.0),
    const FlSpot(1, 1.6),
    const FlSpot(2, 3),
    const FlSpot(3, 1.9),
    const FlSpot(4, 2.8),
    const FlSpot(5, 2.4),
    const FlSpot(6, 2),
  ];

  // Example bar chart data (e.g. monthly returns)
  final List<BarChartGroupData> _monthlyReturnsData = List.generate(6, (index) {
    // Just dummy values for demonstration
    final randomValue = 0.5 + (index % 2 == 0 ? index * 0.2 : index * 0.1);
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: randomValue,
          color: AppColors.primary.withOpacity(0.8),
          width: 12,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  });

  String _selectedRange = '3Y'; // or 5Y, MAX, etc.
  double _investedAmount = 50; // slider value (e.g. 0..100)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- FUND TITLE & STATS SECTION ----
            Text(
              'Motilal Oswal Midcap\nDirect Growth',
              style: AppStyles.h3.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // First column: Invested
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Invested',
                          style: AppStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹1.5k',
                          style: AppStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Vertical divider
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  // Second column: Current Value
                  const Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Current Value',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '₹1.28k',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Vertical divider
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  // Third column: Total Gain
                  const Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total Gain',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        // Value and percentage in a row
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '₹-220.16',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            SizedBox(width: 5),
                            Text(
                              '-14.7',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 16),

            // ---- CHART SECTION (TWO LINES) ----
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.transparent,
                  gridData: const FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    drawHorizontalLine: false, // Disable horizontal lines here
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          String text = '';
                          switch (value.toInt()) {
                            case 0:
                              text = '2021';
                              break;
                            case 2:
                              text = '2022';
                              break;
                            case 4:
                              text = '2023';
                              break;
                            case 6:
                              text = '2024';
                              break;
                          }
                          return Text(
                            text,
                            style: AppStyles.bodySmall
                                .copyWith(color: AppColors.textSecondary),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  lineBarsData: [
                    // "Your Investments" line
                    LineChartBarData(
                      spots: _yourInvestmentsData,
                      isCurved: true,
                      color: Colors.blueAccent,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blueAccent.withOpacity(0.3),
                      ),
                    ),
                    // "Nifty Midcap 150" line
                    LineChartBarData(
                      spots: _niftyMidcapData,
                      isCurved: true,
                      color: Colors.orangeAccent,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.orangeAccent.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ---- TIME RANGE TABS (3Y, 5Y, MAX) ----
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // Set the color of the border
                  width: 0.4, // Set the width of the border
                ),
                borderRadius:
                    BorderRadius.circular(8), // Optional: rounded corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TimeRangeChip(
                    label: '1M',
                    isSelected: _selectedRange == '1M',
                    onTap: () => setState(() => _selectedRange = '1M'),
                  ),
                  TimeRangeChip(
                    label: '3M',
                    isSelected: _selectedRange == '3M',
                    onTap: () => setState(() => _selectedRange = '3M'),
                  ),
                  TimeRangeChip(
                    label: '6M',
                    isSelected: _selectedRange == '6M',
                    onTap: () => setState(() => _selectedRange = '6M'),
                  ),
                  TimeRangeChip(
                    label: '1Y',
                    isSelected: _selectedRange == '1Y',
                    onTap: () => setState(() => _selectedRange = '1Y'),
                  ),
                  TimeRangeChip(
                    label: '3Y',
                    isSelected: _selectedRange == '3Y',
                    onTap: () => setState(() => _selectedRange = '3Y'),
                  ),
                  TimeRangeChip(
                    label: '5Y',
                    isSelected: _selectedRange == '5Y',
                    onTap: () => setState(() => _selectedRange = '5Y'),
                  ),
                  TimeRangeChip(
                    label: 'MAX',
                    isSelected: _selectedRange == 'MAX',
                    onTap: () => setState(() => _selectedRange = 'MAX'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ---- INVESTMENT INFO SECTION ----
            const FundReturnsWidget(),

            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // SELL action
                },
                child: const Text('Sell', style: AppStyles.button),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // INVEST MORE action
                },
                child: const Text('Invest More', style: AppStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- SUPPORTING WIDGETS ----

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final String change;

  const _StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    bool isNegative = change.contains('-');
    Color changeColor = isNegative ? Colors.redAccent : Colors.greenAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                AppStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(value, style: AppStyles.h4.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 2),
        Text(
          change,
          style: AppStyles.bodySmall.copyWith(color: changeColor),
        ),
      ],
    );
  }
}

class _ReturnStat extends StatelessWidget {
  final String label;
  final String value;

  const _ReturnStat({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  AppStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppStyles.h4.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
