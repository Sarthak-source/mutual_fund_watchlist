import 'package:equatable/equatable.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/entities/user_entity.dart';

/// Authentication states
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  otpSent,
  error
}

/// Authentication state class
class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final String? phoneNumber;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.phoneNumber,
    this.errorMessage,
  });

  /// Factory for initial state
  factory AuthState.initial() => const AuthState(
        status: AuthStatus.initial,
      );

  /// Factory for loading state
  factory AuthState.loading() => const AuthState(
        status: AuthStatus.loading,
      );

  /// Factory for authenticated state
  factory AuthState.authenticated(UserEntity user) => AuthState(
        status: AuthStatus.authenticated,
        user: user,
      );

  /// Factory for unauthenticated state
  factory AuthState.unauthenticated() => const AuthState(
        status: AuthStatus.unauthenticated,
      );

  /// Factory for OTP sent state
  factory AuthState.otpSent(String phoneNumber) => AuthState(
        status: AuthStatus.otpSent,
        phoneNumber: phoneNumber,
      );

  /// Factory for error state
  factory AuthState.error(String message) => AuthState(
        status: AuthStatus.error,
        errorMessage: message,
      );

  /// Copy with method to create a new state with some values changed
  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? phoneNumber,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, phoneNumber, errorMessage];
}
