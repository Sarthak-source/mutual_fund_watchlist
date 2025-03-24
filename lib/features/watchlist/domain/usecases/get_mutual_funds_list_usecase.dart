import 'package:dartz/dartz.dart';
import 'package:mutual_fund_watchlist/core/error/failures.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/mutual_fund_entity.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/repositories/mutual_fund_repository.dart';

class GetMutualFundsListUseCase {
  final MutualFundRepository repository;

  GetMutualFundsListUseCase(this.repository);

  Future<Either<Failure, List<MutualFundEntity>>> call() async {
    return await repository.getMutualFundsList();
  }
} 