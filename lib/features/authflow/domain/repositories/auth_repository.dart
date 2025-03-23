import 'package:dartz/dartz.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/entities/user_entity.dart';

/// Core errors that can occur during authentication
abstract class AuthFailure {
  final String message;
  const AuthFailure(this.message);
}

/// Error for invalid credentials
class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure(String message) : super(message);
}

/// Error for network or server issues
class ServerFailure extends AuthFailure {
  const ServerFailure(String message) : super(message);
}

/// Error for user already exists
class UserExistsFailure extends AuthFailure {
  const UserExistsFailure(String message) : super(message);
}

/// Error for OTP verification
class OTPVerificationFailure extends AuthFailure {
  const OTPVerificationFailure(String message) : super(message);
}

/// Interface for the authentication repository
abstract class AuthRepository {
  /// Sign in with email and password
  Future<Either<AuthFailure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  );

  /// Register a new user with email and password
  Future<Either<AuthFailure, UserEntity>> registerWithEmailAndPassword(
    String email,
    String password,
    String? name,
  );

  /// Sign in with mobile OTP
  Future<Either<AuthFailure, void>> signInWithMobileOTP(
    String phoneNumber,
  );

  /// Verify OTP code
  Future<Either<AuthFailure, UserEntity>> verifyOTP(
    String phoneNumber,
    String otpCode,
  );

  /// Sign out the current user
  Future<Either<AuthFailure, void>> signOut();

  /// Get the current authenticated user
  Future<Either<AuthFailure, UserEntity>> getCurrentUser();

  /// Check if the user is authenticated
  Future<bool> isUserAuthenticated();
}
