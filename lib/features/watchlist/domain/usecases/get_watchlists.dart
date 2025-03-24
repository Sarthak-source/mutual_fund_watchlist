import 'package:dartz/dartz.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/watchlist_entity.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/repositories/watchlist_repository.dart';

class GetWatchlists {
  final WatchlistRepository repository;

  GetWatchlists(this.repository);

  Future<Either<Exception, List<WatchlistEntity>>> call() async {
    return await repository.getWatchlists();
  }
} 