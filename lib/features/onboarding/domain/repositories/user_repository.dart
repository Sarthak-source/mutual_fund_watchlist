import 'package:mutual_fund_watchlist/features/onboarding/domain/entities/user.dart';

/// Repository interface for user-related operations
abstract class UserRepository {
  /// Get current user information
  Future<User> getCurrentUser();
  
  /// Update user profile information
  Future<User> updateUserProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
  });
  
  /// Set user's initial onboarding preferences
  Future<void> setOnboardingPreferences({
    required List<String> preferredCategories,
    required String riskProfile,
    required double investmentHorizon,
  });
} 