import 'package:hive/hive.dart';
import 'package:mutual_fund_watchlist/features/watchlist/data/models/mutual_fund_model.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/watchlist_entity.dart';

@HiveType(typeId: 0)
class WatchlistModel extends WatchlistEntity {
  const WatchlistModel({
    required super.id,
    required super.name,
    required List<MutualFundModel> super.funds,
    required super.createdAt,
    required super.updatedAt,
  });

  // -------------------------------
  // Defensive getters
  // -------------------------------

  /// Safely get a string from a dynamic JSON field.
  static String _getString(dynamic value) {
    if (value is String) return value;
    if (value != null) return value.toString();
    return '';
  }

  /// Safely get a DateTime from a dynamic JSON field.
  static DateTime _getDateTime(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return DateTime.fromMillisecondsSinceEpoch(0);
      }
    }
    // If it's a map or something else, handle as needed
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  /// Safely parse the `funds` field which can be a list or a map in some cases.
  static List<MutualFundModel> _parseFunds(dynamic rawFunds) {
    if (rawFunds == null) return [];

    // If it's already a list of dynamic, parse each element.
    if (rawFunds is List) {
      return rawFunds
          .map((fund) => MutualFundModel.fromJson(
                (fund is Map) ? Map<String, dynamic>.from(fund) : {},
              ))
          .toList();
    }

    // If it's a map (e.g., {"0": {...}, "1": {...}}), convert it to a list.
    if (rawFunds is Map) {
      return rawFunds.values
          .map((fund) => MutualFundModel.fromJson(
                (fund is Map) ? Map<String, dynamic>.from(fund) : {},
              ))
          .toList();
    }

    // Otherwise, return empty list.
    return [];
  }

  // -------------------------------
  // fromJson
  // -------------------------------
  factory WatchlistModel.fromJson(Map<String, dynamic> json) {
    return WatchlistModel(
      id: _getString(json['id']),
      name: _getString(json['name']),
      funds: _parseFunds(json['funds']),
      createdAt: _getDateTime(json['created_at']),
      updatedAt: _getDateTime(json['updated_at']),
    );
  }

  // -------------------------------
  // toJson
  // -------------------------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'funds': (funds as List<MutualFundModel>)
          .map((fund) => fund.toJson())
          .toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // -------------------------------
  // fromEntity
  // -------------------------------
  factory WatchlistModel.fromEntity(WatchlistEntity entity) {
    return WatchlistModel(
      id: entity.id,
      name: entity.name,
      funds: entity.funds
          .map((fund) => MutualFundModel.fromEntity(fund))
          .toList(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
