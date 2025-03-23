import 'package:mutual_fund_watchlist/features/onboarding/domain/entities/user.dart';

/// Remote data source interface for user-related operations
abstract class UserRemoteDataSource {
  /// Get current user information from remote API
  Future<User> getCurrentUser();
  
  /// Update user profile information on remote API
  Future<User> updateUserProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
  });
  
  /// Set user's onboarding preferences on remote API
  Future<void> setOnboardingPreferences({
    required List<String> preferredCategories,
    required String riskProfile,
    required double investmentHorizon,
  });
}

/// Implementation of the user remote data source
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  // This would typically use an HTTP client like Dio or http package
  
  @override
  Future<User> getCurrentUser() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Return dummy user data
    return User(
      id: 'user_123',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phoneNumber: '+919876543210',
      isFirstLogin: false,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }
  
  @override
  Future<User> updateUserProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Return updated user data
    return User(
      id: 'user_123',
      name: name ?? 'John Doe',
      email: email ?? 'john.doe@example.com',
      phoneNumber: phoneNumber ?? '+919876543210',
      profileImageUrl: profileImageUrl,
      isFirstLogin: false,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }
  
  @override
  Future<void> setOnboardingPreferences({
    required List<String> preferredCategories,
    required String riskProfile,
    required double investmentHorizon,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    // In a real implementation, this would send data to the backend
    return;
  }
} 