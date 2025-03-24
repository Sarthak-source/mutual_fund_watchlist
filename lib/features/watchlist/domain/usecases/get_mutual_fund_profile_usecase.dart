import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mutual_fund_watchlist/core/error/failures.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/mutual_fund_entity.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/repositories/mutual_fund_repository.dart';

class GetMutualFundProfileUseCase {
  final MutualFundRepository repository;

  GetMutualFundProfileUseCase(this.repository);

  Future<Either<Failure, MutualFundEntity>> call(String isin) async {
    return await repository.getMutualFundProfile(isin);
  }
}

class Params extends Equatable {
  final String isin;

  const Params({required this.isin});

  @override
  List<Object> get props => [isin];
} 