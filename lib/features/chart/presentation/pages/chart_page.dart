import 'dart:math';

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

class ChartConfig {
  final double minX;
  final double maxX;
  final double interval;
  final List<String> labels;
  final List<FlSpot> yourInvestmentsData;
  final List<FlSpot> niftyMidcapData;
  final bool skipLabels;

  ChartConfig({
    required this.minX,
    required this.maxX,
    required this.interval,
    required this.labels,
    required this.yourInvestmentsData,
    required this.niftyMidcapData,
    this.skipLabels = false,
  });

  static List<FlSpot> _generateRandomData(
      int count, double startValue, double volatility,
      {bool isNifty = false}) {
    final random = Random();
    final List<FlSpot> data = [];
    double currentValue = startValue;
    double baselineValue =
        isNifty ? 956.72 : 949.31; // Based on the image values

    for (int i = 0; i < count; i++) {
      // Add some random noise with controlled volatility
      double noise = (random.nextDouble() - 0.5) * volatility * baselineValue;
      // Add periodic movement to simulate market cycles
      double periodic = sin(i * 0.2) * volatility * baselineValue * 0.3;
      // Add trend
      double trend = (i / count) * volatility * baselineValue * 0.5;

      currentValue = baselineValue + noise + periodic + trend;
      // Ensure values stay within reasonable range
      currentValue =
          currentValue.clamp(baselineValue * 0.7, baselineValue * 1.3);
      data.add(FlSpot(i.toDouble(), currentValue));
    }

    return data;
  }

  static ChartConfig getConfigForRange(String range) {
    switch (range) {
      case '1M':
        return ChartConfig(
          minX: 0,
          maxX: 30,
          interval: 10,
          labels: ['1', '10', '20', '30'],
          yourInvestmentsData: _generateRandomData(31, 949.31, 0.05),
          niftyMidcapData: _generateRandomData(31, 956.72, 0.04, isNifty: true),
        );
      case '3M':
        return ChartConfig(
          minX: 0,
          maxX: 90,
          interval: 30,
          labels: ['30', '60', '90'],
          yourInvestmentsData: _generateRandomData(91, 949.31, 0.08),
          niftyMidcapData: _generateRandomData(91, 956.72, 0.06, isNifty: true),
        );
      case '6M':
        return ChartConfig(
          minX: 0,
          maxX: 180,
          interval: 60,
          labels: ['60', '120', '180'],
          yourInvestmentsData: _generateRandomData(181, 949.31, 0.12),
          niftyMidcapData:
              _generateRandomData(181, 956.72, 0.10, isNifty: true),
        );
      case '1Y':
        return ChartConfig(
          minX: 0,
          maxX: 12,
          interval: 3,
          labels: ['Jan', 'Apr', 'Jul', 'Oct', 'Dec'],
          yourInvestmentsData: _generateRandomData(13, 949.31, 0.15),
          niftyMidcapData: _generateRandomData(13, 956.72, 0.12, isNifty: true),
        );
      case '3Y':
        return ChartConfig(
          minX: 0,
          maxX: 3,
          interval: 1,
          labels: ['2022', '2023', '2024', '2025'],
          yourInvestmentsData: _generateRandomData(48, 949.31, 0.25),
          niftyMidcapData: _generateRandomData(48, 956.72, 0.20, isNifty: true),
          skipLabels: true,
        );
      case '5Y':
        return ChartConfig(
          minX: 0,
          maxX: 5,
          interval: 1,
          labels: ['2020', '2021', '2022', '2023', '2024', '2025'],
          yourInvestmentsData: _generateRandomData(60, 949.31, 0.35),
          niftyMidcapData: _generateRandomData(60, 956.72, 0.30, isNifty: true),
          skipLabels: true,
        );
      case 'MAX':
        return ChartConfig(
          minX: 0,
          maxX: 10,
          interval: 2,
          labels: ['2015', '2017', '2019', '2021', '2023', '2025'],
          yourInvestmentsData: _generateRandomData(120, 949.31, 0.45),
          niftyMidcapData:
              _generateRandomData(120, 956.72, 0.40, isNifty: true),
          skipLabels: true,
        );
      default:
        return ChartConfig(
          minX: 0,
          maxX: 3,
          interval: 1,
          labels: ['2022', '2023', '2024', '2025'],
          yourInvestmentsData: _generateRandomData(48, 949.31, 0.20),
          niftyMidcapData: _generateRandomData(48, 956.72, 0.15, isNifty: true),
          skipLabels: true,
        );
    }
  }
}

class _ChartPageState extends State<ChartPage> {
  String _selectedRange = '3Y';
  double? _touchedX;
  List<double>? _touchedValues;

  ChartConfig get _currentConfig =>
      ChartConfig.getConfigForRange(_selectedRange);

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
            Padding(
  padding: const EdgeInsets.symmetric(vertical: 5),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      // "Nov ₹104.2" in white using bodyMedium as the base
      Text(
        'Nov ₹104.2',
        style: AppStyles.bodyMedium.copyWith(color: Colors.white),
      ),

      // Vertical divider
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Text(
          '|',
          style: AppStyles.bodyMedium.copyWith(color: Colors.white),
        ),
      ),

      // "1D ₹ -4.7 -3.7"
      Row(
        children: [
          Text(
            '1D ',
            style: AppStyles.bodySmall.copyWith(color: Colors.grey),
          ),
          Text(
            '₹ -4.7 ',
            style: AppStyles.bodySmall.copyWith(color: Colors.red),
          ),
          const SizedBox(width: 3,),
          Text(
            '^',
            style: AppStyles.bodySmall.copyWith(color: Colors.red),
          ),
          Text(
            '-3.7',
            style: AppStyles.bodySmall.copyWith(color: Colors.red),
          ),
        ],
      ),
    ],
  ),
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
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Current Value',
                          style: AppStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹1.28k',
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
                  // Third column: Total Gain
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total Gain',
                          style: AppStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Value and percentage in a row
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '₹-220.16',
                              style: AppStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '-14.7',
                              style: AppStyles.caption.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Your Investments
                    Row(
                      children: [
                        // Colored line
                        Container(
                          width: 12,
                          height: 2,
                          color: AppColors.primary, // Blue color
                        ),
                        const SizedBox(width: 6),
                        // Text
                        Text(
                          'Your Investments -19.75%',
                          style: AppStyles.caption.copyWith(
                            fontSize: 14,
                            color: AppColors.primary, // Same blue color
                          ),
                        ),
                      ],
                    ),

                    // Nifty Midcap 150
                    Row(
                      children: [
                        // Colored line
                        Container(
                          width: 12,
                          height: 2,
                          color: Colors.orangeAccent, // Yellow color
                        ),
                        const SizedBox(width: 6),
                        // Text
                        Text(
                          'Nifty Midcap 150 -12.97%',
                          style: AppStyles.caption.copyWith(
                            fontSize: 14,
                            color: Colors.orangeAccent, // Same yellow color
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF4F4F4F)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'NAV',
                    style: AppStyles.caption.copyWith(
                      color: const Color.fromARGB(255, 173, 173, 173),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // ---- CHART SECTION (TWO LINES) ----
            _buildChart(),

            const SizedBox(height: 16),

            // ---- TIME RANGE TABS (3Y, 5Y, MAX) ----
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // Set the color of the border
                  width: 0.4, // Set the width of the border
                ),
                borderRadius: BorderRadius.circular(8), // Rounded corners
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
              child: ElevatedButton.icon(
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
                icon: const Icon(
                  Icons.arrow_downward,
                  color: AppColors.textPrimary,
                  size: 14,
                ),
                label: const Text('Sell', style: AppStyles.button),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
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
                icon: const Icon(
                  Icons.arrow_upward,
                  color: AppColors.textPrimary,
                  size: 14,
                ),
                label: const Text('Invest More', style: AppStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    return Stack(
      children: [
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              minX: _currentConfig.minX,
              maxX: _currentConfig.maxX,
              backgroundColor: Colors.transparent,
              gridData: const FlGridData(
                show: true,
                drawVerticalLine: false,
                drawHorizontalLine: false,
              ),
              borderData: FlBorderData(show: false),
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.transparent,
                  tooltipPadding: EdgeInsets.zero,
                  tooltipMargin: 0,
                  getTooltipItems: (touchedSpots) {
                    return [];
                  },
                ),
                touchCallback:
                    (FlTouchEvent event, LineTouchResponse? touchResponse) {
                  setState(() {
                    if (event is FlPanEndEvent ||
                        event is FlTapUpEvent ||
                        touchResponse == null ||
                        touchResponse.lineBarSpots == null) {
                      _touchedX = null;
                      _touchedValues = null;
                    } else {
                      _touchedX = touchResponse.lineBarSpots![0].x;
                      _touchedValues = touchResponse.lineBarSpots!
                          .map((spot) => spot.y)
                          .toList();
                    }
                  });
                },
                getTouchedSpotIndicator:
                    (LineChartBarData barData, List<int> spotIndexes) {
                  return spotIndexes.map((spotIndex) {
                    return TouchedSpotIndicatorData(
                      FlLine(
                        color: Colors.white.withOpacity(0.2),
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      ),
                      FlDotData(
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: barData.color ?? Colors.white,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    );
                  }).toList();
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: _currentConfig.interval,
                    reservedSize: 22,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < _currentConfig.labels.length) {
                        if (_currentConfig.skipLabels && index % 2 == 1) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          _currentConfig.labels[index],
                          style: AppStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
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
                LineChartBarData(
                  spots: _currentConfig.yourInvestmentsData,
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: _touchedX != null,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.primary,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                ),
                LineChartBarData(
                  spots: _currentConfig.niftyMidcapData,
                  isCurved: true,
                  color: Colors.orangeAccent,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: _touchedX != null,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: Colors.orangeAccent,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.orangeAccent.withOpacity(0.1),
                  ),
                ),
              ],
              extraLinesData: ExtraLinesData(
                verticalLines: _touchedX != null
                    ? [
                        VerticalLine(
                          x: _touchedX!,
                          color: Colors.white.withOpacity(0.2),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        ),
                      ]
                    : [],
              ),
            ),
          ),
        ),
        if (_touchedX != null && _touchedValues != null)
          Positioned(
            top: 0,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '09-01-2022',
                    style: AppStyles.caption.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your Investment: ₹${_touchedValues![0].toStringAsFixed(2)}',
                    style:
                        AppStyles.bodySmall.copyWith(color: AppColors.primary),
                  ),
                  Text(
                    'Nifty Midcap: ₹${_touchedValues![1].toStringAsFixed(2)}',
                    style: AppStyles.bodySmall
                        .copyWith(color: Colors.orangeAccent),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
