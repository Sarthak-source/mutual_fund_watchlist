import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/mutual_fund_entity.dart';

class MutualFundModel extends MutualFundEntity {
  const MutualFundModel({
    required String isin,
    required String name,
    required String category,
    required double nav,
    required double oneYearReturn,
    required double threeYearReturn,
    required double fiveYearReturn,
    String? description,
    String? amc,
    String symbol = '',
    double currentPrice = 0.0,
    double changePercent = 0.0,
    double netAssetValue = 0.0,
    double ytdReturn = 0.0,
  }) : super(
          isin: isin,
          name: name,
          category: category,
          nav: nav,
          oneYearReturn: oneYearReturn,
          threeYearReturn: threeYearReturn,
          fiveYearReturn: fiveYearReturn,
          description: description,
          amc: amc,
          symbol: symbol,
          currentPrice: currentPrice,
          changePercent: changePercent,
          netAssetValue: netAssetValue,
          ytdReturn: ytdReturn,
        );

  factory MutualFundModel.fromJson(Map<String, dynamic> json) {
    return MutualFundModel(
      isin: json['isin'] as String,
      name: json['name'] as String,
      category: json['category'] ?? 'Unknown',
      nav: (json['nav'] != null) ? double.parse(json['nav'].toString()) : 0.0,
      oneYearReturn: (json['1y'] != null) ? double.parse(json['1y'].toString()) : 0.0,
      threeYearReturn: (json['3y'] != null) ? double.parse(json['3y'].toString()) : 0.0,
      fiveYearReturn: (json['5y'] != null) ? double.parse(json['5y'].toString()) : 0.0,
      description: json['description'] as String?,
      amc: json['amc'] as String?,
      symbol: json['symbol'] as String? ?? '',
      currentPrice: (json['price'] != null) ? double.parse(json['price'].toString()) : 0.0,
      changePercent: (json['change_percent'] != null) ? double.parse(json['change_percent'].toString()) : 0.0,
      netAssetValue: (json['nav'] != null) ? double.parse(json['nav'].toString()) : 0.0,
      ytdReturn: (json['ytd'] != null) ? double.parse(json['ytd'].toString()) : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isin': isin,
      'name': name,
      'category': category,
      'nav': nav,
      '1y': oneYearReturn,
      '3y': threeYearReturn,
      '5y': fiveYearReturn,
      'description': description,
      'amc': amc,
      'symbol': symbol,
      'price': currentPrice,
      'change_percent': changePercent,
      'ytd': ytdReturn,
    };
  }
} 