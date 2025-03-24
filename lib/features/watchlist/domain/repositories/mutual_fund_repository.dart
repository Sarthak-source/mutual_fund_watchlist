import 'package:dartz/dartz.dart';
import 'package:mutual_fund_watchlist/core/error/failures.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/mutual_fund_entity.dart';

abstract class MutualFundRepository {
  Future<Either<Failure, List<MutualFundEntity>>> getMutualFundsList();
  Future<Either<Failure, MutualFundEntity>> getMutualFundProfile(String isin);
} 