import 'package:dartz/dartz.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/entities/user_entity.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/repositories/auth_repository.dart';

/// Use case to get the current user
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  /// Execute the get current user use case
  Future<Either<AuthFailure, UserEntity>> call() {
    return repository.getCurrentUser();
  }
} 