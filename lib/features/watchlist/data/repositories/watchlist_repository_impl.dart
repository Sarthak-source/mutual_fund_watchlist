import 'package:dartz/dartz.dart';
import 'package:mutual_fund_watchlist/features/watchlist/data/datasources/watchlist_local_data_source.dart';
import 'package:mutual_fund_watchlist/features/watchlist/data/models/watchlist_model.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/watchlist_entity.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/repositories/watchlist_repository.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource localDataSource;

  WatchlistRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Exception, List<WatchlistEntity>>> getWatchlists() async {
    try {
      final watchlists = await localDataSource.getWatchlists();
      return Right(watchlists);
    } catch (e) {
      return Left(Exception('Failed to get watchlists: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, WatchlistEntity>> getWatchlistById(String id) async {
    try {
      final watchlist = await localDataSource.getWatchlistById(id);
      return Right(watchlist);
    } catch (e) {
      return Left(Exception('Failed to get watchlist: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, void>> saveWatchlist(WatchlistEntity watchlist) async {
    try {
      // Convert the entity to a model here.
      final watchlistModel = WatchlistModel.fromEntity(watchlist);
      await localDataSource.saveWatchlist(watchlistModel);
      return const Right(null);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> deleteWatchlist(String id) async {
    try {
      await localDataSource.deleteWatchlist(id);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to delete watchlist: ${e.toString()}'));
    }
  }
}
