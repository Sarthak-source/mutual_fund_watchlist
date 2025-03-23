import 'package:dartz/dartz.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/repositories/auth_repository.dart';

/// Use case to sign out the current user
class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  /// Execute the sign out use case
  Future<Either<AuthFailure, void>> call() {
    return repository.signOut();
  }
} 