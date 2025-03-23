import 'package:mutual_fund_watchlist/features/onboarding/domain/entities/user.dart';
import 'package:mutual_fund_watchlist/features/onboarding/domain/repositories/user_repository.dart';

/// Use case for getting the current user information
class GetCurrentUserUseCase {
  final UserRepository repository;

  GetCurrentUserUseCase(this.repository);

  /// Execute the use case to retrieve current user
  Future<User> execute() async {
    return await repository.getCurrentUser();
  }
} 