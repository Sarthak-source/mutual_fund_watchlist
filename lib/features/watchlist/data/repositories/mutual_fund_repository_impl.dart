import 'package:dartz/dartz.dart';
import 'package:mutual_fund_watchlist/core/error/failures.dart';
import 'package:mutual_fund_watchlist/features/watchlist/data/datasources/mutual_fund_remote_data_source.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/mutual_fund_entity.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/repositories/mutual_fund_repository.dart';

class MutualFundRepositoryImpl implements MutualFundRepository {
  final MutualFundRemoteDataSource remoteDataSource;

  MutualFundRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MutualFundEntity>>> getMutualFundsList() async {
    try {
      // For now, use mock data to avoid needing an API key
      final result = await remoteDataSource.getMockMutualFundsList();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MutualFundEntity>> getMutualFundProfile(String isin) async {
    try {
      final result = await remoteDataSource.getMutualFundProfile(isin);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
} 