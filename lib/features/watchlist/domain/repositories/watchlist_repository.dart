import 'package:dartz/dartz.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/watchlist_entity.dart';

abstract class WatchlistRepository {
  Future<Either<Exception, List<WatchlistEntity>>> getWatchlists();
  Future<Either<Exception, WatchlistEntity>> getWatchlistById(String id);
  Future<Either<Exception, void>> saveWatchlist(WatchlistEntity watchlist);
  Future<Either<Exception, void>> deleteWatchlist(String id);
}
