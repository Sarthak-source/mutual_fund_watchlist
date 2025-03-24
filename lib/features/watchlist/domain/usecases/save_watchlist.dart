import 'package:dartz/dartz.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/watchlist_entity.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/repositories/watchlist_repository.dart';

class SaveWatchlist {
  final WatchlistRepository repository;

  SaveWatchlist(this.repository);

  Future<Either<Exception, void>> call(WatchlistEntity watchlist) async {
    return await repository.saveWatchlist(watchlist);
  }
} 