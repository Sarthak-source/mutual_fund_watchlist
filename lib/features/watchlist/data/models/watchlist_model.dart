import 'package:mutual_fund_watchlist/features/watchlist/data/models/mutual_fund_model.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/watchlist_entity.dart';

class WatchlistModel extends WatchlistEntity {
  const WatchlistModel({
    required String id,
    required String name,
    required List<MutualFundModel> funds,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          name: name,
          funds: funds,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory WatchlistModel.fromJson(Map<String, dynamic> json) {
    return WatchlistModel(
      id: json['id'] as String,
      name: json['name'] as String,
      funds: (json['funds'] as List<dynamic>)
          .map((fund) =>
              MutualFundModel.fromJson(fund as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'funds':
          (funds as List<MutualFundModel>).map((fund) => fund.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Helper conversion from entity to model
  factory WatchlistModel.fromEntity(WatchlistEntity entity) {
    return WatchlistModel(
      id: entity.id,
      name: entity.name,
      funds: entity.funds.map((fund) {
        // Ensure you have a similar conversion in MutualFundModel
        return MutualFundModel.fromEntity(fund);
      }).toList(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
