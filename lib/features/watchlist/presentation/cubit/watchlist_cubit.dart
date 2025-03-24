import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/watchlist_entity.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/usecases/get_mutual_funds_list_usecase.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/cubit/watchlist_state.dart';
import 'package:uuid/uuid.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final GetMutualFundsListUseCase getMutualFundsList;

  WatchlistCubit({
    required this.getMutualFundsList,
  }) : super(WatchlistState.initial());

  Future<void> loadWatchlists() async {
    emit(state.copyWith(status: WatchlistStatus.loading));

    try {
      // In a real app, we would fetch watchlists from a repository
      // For now, create a demo watchlist with funds from the API
      final result = await getMutualFundsList();
      
      result.fold(
        (failure) {
          emit(state.copyWith(
            status: WatchlistStatus.error,
            errorMessage: failure.message,
          ));
        },
        (funds) {
          // Create a demo watchlist with the funds
          final watchlist = WatchlistEntity(
            id: const Uuid().v4(),
            name: 'Watchlist 1',
            funds: funds,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          
          // Create an empty second watchlist
          final emptyWatchlist = WatchlistEntity(
            id: const Uuid().v4(),
            name: 'Watchlist 2',
            funds: [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          
          emit(state.copyWith(
            status: WatchlistStatus.loaded,
            watchlists: [watchlist, emptyWatchlist],
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: WatchlistStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void changeTab(int index) {
    if (index >= 0 && index < state.watchlists.length) {
      emit(state.copyWith(selectedTabIndex: index));
    }
  }

  Future<void> createWatchlist(String name) async {
    final newWatchlist = WatchlistEntity(
      id: const Uuid().v4(),
      name: name,
      funds: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    final updatedWatchlists = List<WatchlistEntity>.from(state.watchlists)
      ..add(newWatchlist);
    
    emit(state.copyWith(
      watchlists: updatedWatchlists,
      selectedTabIndex: updatedWatchlists.length - 1,
    ));
  }

  // Add more methods for watchlist management (add fund, remove fund, etc.)
}
