import 'package:mutual_fund_watchlist/features/authflow/domain/repositories/auth_repository.dart';

/// Use case to check if the user is authenticated
class IsAuthenticatedUseCase {
  final AuthRepository repository;

  IsAuthenticatedUseCase(this.repository);

  /// Execute the is authenticated use case
  Future<bool> call() {
    return repository.isUserAuthenticated();
  }
} 