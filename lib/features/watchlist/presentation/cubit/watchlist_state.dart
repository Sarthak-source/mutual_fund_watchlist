import 'package:equatable/equatable.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/watchlist_entity.dart';

enum WatchlistStatus {
  initial,
  loading,
  loaded,
  error,
}

class WatchlistState extends Equatable {
  final WatchlistStatus status;
  final List<WatchlistEntity> watchlists;
  final String? errorMessage;
  final int selectedTabIndex;

  const WatchlistState({
    required this.status,
    required this.watchlists,
    this.errorMessage,
    this.selectedTabIndex = 0,
  });

  factory WatchlistState.initial() {
    return const WatchlistState(
      status: WatchlistStatus.initial,
      watchlists: [],
    );
  }

  bool get isEmpty => watchlists.isEmpty;

  WatchlistEntity? get selectedWatchlist {
    if (watchlists.isEmpty || selectedTabIndex >= watchlists.length) {
      return null;
    }
    return watchlists[selectedTabIndex];
  }

  WatchlistState copyWith({
    WatchlistStatus? status,
    List<WatchlistEntity>? watchlists,
    String? errorMessage,
    int? selectedTabIndex,
  }) {
    return WatchlistState(
      status: status ?? this.status,
      watchlists: watchlists ?? this.watchlists,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  @override
  List<Object?> get props => [status, watchlists, errorMessage, selectedTabIndex];
}
