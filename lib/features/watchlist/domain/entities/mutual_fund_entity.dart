import 'package:equatable/equatable.dart';

class MutualFundEntity extends Equatable {
  final String isin;
  final String name;
  final String category;
  final double nav;
  final double oneYearReturn;
  final double threeYearReturn;
  final double fiveYearReturn;
  final String? description;
  final String? amc; // Asset Management Company
  
  // Additional properties for UI display
  final String symbol;
  final double currentPrice;
  final double changePercent;
  final double netAssetValue;
  final double ytdReturn;

  const MutualFundEntity({
    required this.isin,
    required this.name,
    required this.category,
    required this.nav,
    required this.oneYearReturn,
    required this.threeYearReturn,
    required this.fiveYearReturn,
    this.description,
    this.amc,
    this.symbol = '',
    this.currentPrice = 0.0,
    this.changePercent = 0.0,
    this.netAssetValue = 0.0,
    this.ytdReturn = 0.0,
  });

  @override
  List<Object?> get props => [
        isin,
        name,
        category,
        nav,
        oneYearReturn,
        threeYearReturn,
        fiveYearReturn,
        description,
        amc,
        symbol,
        currentPrice,
        changePercent,
        netAssetValue,
        ytdReturn,
      ];
} 