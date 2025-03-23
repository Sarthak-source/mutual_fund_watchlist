import 'package:mutual_fund_watchlist/features/onboarding/data/datasources/user_remote_data_source.dart';
import 'package:mutual_fund_watchlist/features/onboarding/domain/entities/user.dart';
import 'package:mutual_fund_watchlist/features/onboarding/domain/repositories/user_repository.dart';

/// Implementation of the user repository
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> getCurrentUser() async {
    try {
      return await remoteDataSource.getCurrentUser();
    } catch (e) {
      // In a real app, you might want to handle specific exceptions
      // and potentially map them to custom exceptions or return default values
      rethrow;
    }
  }

  @override
  Future<User> updateUserProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      return await remoteDataSource.updateUserProfile(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> setOnboardingPreferences({
    required List<String> preferredCategories,
    required String riskProfile,
    required double investmentHorizon,
  }) async {
    try {
      await remoteDataSource.setOnboardingPreferences(
        preferredCategories: preferredCategories,
        riskProfile: riskProfile,
        investmentHorizon: investmentHorizon,
      );
    } catch (e) {
      rethrow;
    }
  }
} 