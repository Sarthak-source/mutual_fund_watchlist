import 'package:equatable/equatable.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/mutual_fund_entity.dart';

class WatchlistEntity extends Equatable {
  final String id;
  final String name;
  final List<MutualFundEntity> funds;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WatchlistEntity({
    required this.id,
    required this.name,
    required this.funds,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, funds, createdAt, updatedAt];

  bool get isEmpty => funds.isEmpty;

  WatchlistEntity copyWith({
    String? id,
    String? name,
    List<MutualFundEntity>? funds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WatchlistEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      funds: funds ?? this.funds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 