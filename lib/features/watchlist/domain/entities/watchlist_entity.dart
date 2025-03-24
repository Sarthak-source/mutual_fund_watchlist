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
} 