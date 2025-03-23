import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/usecases/get_current_user_usecase.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/usecases/is_authenticated_usecase.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/usecases/sign_in_with_mobile_otp_usecase.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/usecases/sign_out_usecase.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/usecases/verify_otp_usecase.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/cubit/auth_state.dart';

/// Authentication cubit for managing authentication state
class AuthCubit extends Cubit<AuthState> {
  final SignInWithMobileOTPUseCase _signInWithMobileOTPUseCase;
  final VerifyOTPUseCase _verifyOTPUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final IsAuthenticatedUseCase _isAuthenticatedUseCase;

  AuthCubit({
    required SignInWithMobileOTPUseCase signInWithMobileOTPUseCase,
    required VerifyOTPUseCase verifyOTPUseCase,
    required SignOutUseCase signOutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required IsAuthenticatedUseCase isAuthenticatedUseCase,
  })  : _signInWithMobileOTPUseCase = signInWithMobileOTPUseCase,
        _verifyOTPUseCase = verifyOTPUseCase,
        _signOutUseCase = signOutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _isAuthenticatedUseCase = isAuthenticatedUseCase,
        super(AuthState.initial());

  /// Check the current authentication status
  Future<void> checkAuthStatus() async {
    emit(AuthState.loading());
    final isAuthenticated = await _isAuthenticatedUseCase();
    
    if (isAuthenticated) {
      final result = await _getCurrentUserUseCase();
      result.fold(
        (failure) => emit(AuthState.error(failure.message)),
        (user) => emit(AuthState.authenticated(user)),
      );
    } else {
      emit(AuthState.unauthenticated());
    }
  }

  /// Request OTP with phone number
  Future<void> requestOTP({required String phoneNumber}) async {
    emit(AuthState.loading());
    final result = await _signInWithMobileOTPUseCase(phoneNumber);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(AuthState.otpSent(phoneNumber)),
    );
  }

  /// Verify OTP code
  Future<void> verifyOTP({
    required String phoneNumber,
    required String otpCode,
  }) async {
    emit(AuthState.loading());
    final result = await _verifyOTPUseCase(phoneNumber, otpCode);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  /// Sign out the current user
  Future<void> signOut() async {
    emit(AuthState.loading());
    final result = await _signOutUseCase();
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(AuthState.unauthenticated()),
    );
  }
}
