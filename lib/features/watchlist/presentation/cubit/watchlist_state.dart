import 'package:equatable/equatable.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/watchlist_entity.dart';

enum WatchlistStatus {
  initial,
  loading,
  loaded,
  error,
}

abstract class WatchlistState extends Equatable {
  const WatchlistState();
  
  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistEmpty extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<WatchlistEntity> watchlists;
  final WatchlistEntity selectedWatchlist;

  const WatchlistLoaded({
    required this.watchlists,
    required this.selectedWatchlist,
  });

  @override
  List<Object?> get props => [watchlists, selectedWatchlist];
}

class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError({required this.message});

  @override
  List<Object?> get props => [message];
}
