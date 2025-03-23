import 'package:flutter/foundation.dart';
import 'package:mutual_fund_watchlist/features/authflow/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Exception for authentication errors
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

/// Interface for authentication data source
abstract class AuthRemoteDataSource {
  /// Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword(String email, String password);

  /// Register with email and password
  Future<UserModel> registerWithEmailAndPassword(String email, String password, String? name);

  /// Sign in with mobile OTP
  Future<void> signInWithMobileOTP(String phoneNumber);
  
  /// Verify OTP code
  Future<UserModel> verifyOTP(String phoneNumber, String otpCode);

  /// Sign out current user
  Future<void> signOut();

  /// Get current user
  Future<UserModel?> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isUserAuthenticated();
}

/// Implementation of AuthRemoteDataSource using Supabase
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;

  AuthRemoteDataSourceImpl({required SupabaseClient supabaseClient}) : _supabaseClient = supabaseClient;

  @override
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AuthException('Invalid credentials');
      }

      return UserModel.fromSupabase(response.user!.toJson());
    } on AuthException {
      rethrow;
    } catch (e) {
      debugPrint('Sign in error: $e');
      throw AuthException('Authentication failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> registerWithEmailAndPassword(String email, String password, String? name) async {
    try {
      final userMetadata = name != null ? {'name': name} : null;

      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: userMetadata,
      );

      if (response.user == null) {
        throw AuthException('User registration failed');
      }

      return UserModel.fromSupabase(response.user!.toJson());
    } on AuthException {
      rethrow;
    } catch (e) {
      debugPrint('Registration error: $e');
      throw AuthException('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signInWithMobileOTP(String phoneNumber) async {
    try {
      // Format phone number if needed
      final formattedPhone = phoneNumber.startsWith('+') ? phoneNumber : '+$phoneNumber';
      
      await _supabaseClient.auth.signInWithOtp(
        phone: formattedPhone,
      );
    } catch (e) {
      debugPrint('Mobile OTP sign in error: $e');
      throw AuthException('Failed to send OTP: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> verifyOTP(String phoneNumber, String otpCode) async {
    try {
      // Format phone number if needed
      final formattedPhone = phoneNumber.startsWith('+') ? phoneNumber : '+$phoneNumber';
      
      final response = await _supabaseClient.auth.verifyOTP(
        phone: formattedPhone,
        token: otpCode,
        type: OtpType.sms,
      );

      if (response.user == null) {
        throw AuthException('OTP verification failed');
      }

      return UserModel.fromSupabase(response.user!.toJson());
    } on AuthException {
      rethrow;
    } catch (e) {
      debugPrint('OTP verification error: $e');
      throw AuthException('OTP verification failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
      throw AuthException('Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        return null;
      }
      return UserModel.fromSupabase(user.toJson());
    } catch (e) {
      debugPrint('Get current user error: $e');
      throw AuthException('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<bool> isUserAuthenticated() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      return user != null;
    } catch (e) {
      debugPrint('Auth check error: $e');
      return false;
    }
  }
} 