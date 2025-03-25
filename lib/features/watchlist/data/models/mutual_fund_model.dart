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

  // -------------------------------
  // Defensive helper getters
  // -------------------------------
  static String _getString(dynamic value) {
    if (value is String) return value;
    if (value != null) return value.toString();
    return '';
  }

  static double _getDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) {
      return value.toDouble();
    }
    // If it's a string that can be parsed to double:
    try {
      return double.parse(value.toString());
    } catch (_) {
      return 0.0;
    }
  }

  // -------------------------------
  // fromJson
  // -------------------------------
  factory MutualFundModel.fromJson(Map<String, dynamic> json) {
    return MutualFundModel(
      isin: _getString(json['isin']),
      name: _getString(json['name']),
      category: (json['category'] is String)
          ? json['category'] as String
          : 'Unknown',
      nav: _getDouble(json['nav']),
      oneYearReturn: _getDouble(json['1y']),
      threeYearReturn: _getDouble(json['3y']),
      fiveYearReturn: _getDouble(json['5y']),
      description: _getString(json['description']),
      amc: _getString(json['amc']),
      symbol: _getString(json['symbol']),
      currentPrice: _getDouble(json['price']),
      changePercent: _getDouble(json['change_percent']),
      netAssetValue: _getDouble(json['nav']), // same as 'nav' above
      ytdReturn: _getDouble(json['ytd']),
    );
  }

  // -------------------------------
  // toJson
  // -------------------------------
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

  // -------------------------------
  // fromEntity
  // -------------------------------
  factory MutualFundModel.fromEntity(MutualFundEntity entity) {
    return MutualFundModel(
      isin: entity.isin,
      name: entity.name,
      category: entity.category,
      nav: entity.nav,
      oneYearReturn: entity.oneYearReturn,
      threeYearReturn: entity.threeYearReturn,
      fiveYearReturn: entity.fiveYearReturn,
      description: entity.description,
      amc: entity.amc,
      symbol: entity.symbol,
      currentPrice: entity.currentPrice,
      changePercent: entity.changePercent,
      netAssetValue: entity.netAssetValue,
      ytdReturn: entity.ytdReturn,
    );
  }
}
