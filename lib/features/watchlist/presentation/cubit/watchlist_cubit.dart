import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mutual_fund_watchlist/features/watchlist/data/models/watchlist_model.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/mutual_fund_entity.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/watchlist_entity.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/usecases/delete_watchlist.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/usecases/get_watchlists.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/usecases/save_watchlist.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/cubit/watchlist_state.dart';
import 'package:uuid/uuid.dart';


class WatchlistCubit extends Cubit<WatchlistState> {
  final GetWatchlists getWatchlists;
  final SaveWatchlist saveWatchlist;
  final DeleteWatchlist deleteWatchlist;

  WatchlistCubit({
    required this.getWatchlists,
    required this.saveWatchlist,
    required this.deleteWatchlist,
  }) : super(WatchlistInitial());

  Future<void> loadWatchlists() async {
    emit(WatchlistLoading());
    final result = await getWatchlists();
    result.fold(
      (failure) => emit(WatchlistError(message: failure.toString())),
      (watchlists) {
        if (watchlists.isEmpty) {
          emit(WatchlistEmpty());
        } else {
          emit(WatchlistLoaded(
            watchlists: watchlists,
            selectedWatchlist: watchlists.first,
          ));
        }
      },
    );
  }

  Future<void> createWatchlist(String name) async {
    emit(WatchlistLoading());
    final newWatchlist = WatchlistEntity(
      id: const Uuid().v4(),
      name: name,
      funds: const [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await saveWatchlist(newWatchlist);
    result.fold(
      (failure) => emit(WatchlistError(message: failure.toString())),
      (_) => loadWatchlists(),
    );
  }

  Future<void> deleteWatchlistById(String id) async {
    emit(WatchlistLoading());
    final result = await deleteWatchlist(id);
    result.fold(
      (failure) => emit(WatchlistError(message: failure.toString())),
      (_) => loadWatchlists(),
    );
  }

  void selectWatchlist(WatchlistEntity watchlist) {
    if (state is WatchlistLoaded) {
      final currentState = state as WatchlistLoaded;
      emit(WatchlistLoaded(
        watchlists: currentState.watchlists,
        selectedWatchlist: watchlist,
      ));
    }
  }

  Future<void> addFundToWatchlist(MutualFundEntity fund) async {
  if (state is WatchlistLoaded) {
    final currentState = state as WatchlistLoaded;
    final selectedWatchlist = currentState.selectedWatchlist;
    
    if (selectedWatchlist.funds.any((f) => f.isin == fund.isin)) {
      return;
    }
    
    final updatedFunds = [...selectedWatchlist.funds, fund];
    final updatedWatchlist = WatchlistEntity(
      id: selectedWatchlist.id,
      name: selectedWatchlist.name,
      funds: updatedFunds,
      createdAt: selectedWatchlist.createdAt,
      updatedAt: DateTime.now(),
    );
    
    // Convert to model
    final updatedWatchlistModel = WatchlistModel.fromEntity(updatedWatchlist);

    final result = await saveWatchlist(updatedWatchlistModel);
    result.fold(
      (failure) => emit(WatchlistError(message: failure.toString())),
      (_) => loadWatchlists(),
    );
  }
}


  Future<void> removeFundFromWatchlist(MutualFundEntity fund) async {
    if (state is WatchlistLoaded) {
      final currentState = state as WatchlistLoaded;
      final selectedWatchlist = currentState.selectedWatchlist;
      
      final updatedFunds = selectedWatchlist.funds
          .where((f) => f.isin != fund.isin)
          .toList();
          
      final updatedWatchlist = WatchlistEntity(
        id: selectedWatchlist.id,
        name: selectedWatchlist.name,
        funds: updatedFunds,
        createdAt: selectedWatchlist.createdAt,
        updatedAt: DateTime.now(),
      );
      
      final result = await saveWatchlist(updatedWatchlist);
      result.fold(
        (failure) => emit(WatchlistError(message: failure.toString())),
        (_) {
          // If no funds left, reload all watchlists to update UI
          if (updatedFunds.isEmpty) {
            loadWatchlists();
          } else {
            // Otherwise, update the current state directly
            emit(WatchlistLoaded(
              watchlists: currentState.watchlists.map((w) {
                if (w.id == updatedWatchlist.id) {
                  return updatedWatchlist;
                }
                return w;
              }).toList(),
              selectedWatchlist: updatedWatchlist,
            ));
          }
        },
      );
    }
  }
}
