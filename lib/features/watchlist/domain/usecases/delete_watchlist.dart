import 'package:dartz/dartz.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/repositories/watchlist_repository.dart';

class DeleteWatchlist {
  final WatchlistRepository repository;

  DeleteWatchlist(this.repository);

  Future<Either<Exception, void>> call(String id) async {
    return await repository.deleteWatchlist(id);
  }
} 