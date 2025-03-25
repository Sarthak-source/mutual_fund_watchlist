import 'package:dartz/dartz.dart';
import 'package:mutual_fund_watchlist/core/error/failures.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/mutual_fund_entity.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/repositories/mutual_fund_repository.dart';

class SearchMutualFundsUseCase {
  final MutualFundRepository repository;

  SearchMutualFundsUseCase(this.repository);

  Future<Either<Failure, List<MutualFundEntity>>> call(String query) async {
    final result = await repository.getMutualFundsList();
    return result.fold(
      (failure) => Left(failure),
      (funds) {
        if (query.isEmpty) {
          return Right(funds);
        }
        
        final lowercaseQuery = query.toLowerCase();
        final filteredFunds = funds.where((fund) {
          return fund.name.toLowerCase().contains(lowercaseQuery) ||
              fund.category.toLowerCase().contains(lowercaseQuery) ||
              (fund.amc?.toLowerCase().contains(lowercaseQuery) ?? false);
        }).toList();
        
        return Right(filteredFunds);
      },
    );
  }
} 