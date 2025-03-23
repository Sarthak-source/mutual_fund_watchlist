import 'package:dartz/dartz.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/repositories/auth_repository.dart';

class SignInWithMobileOTPUseCase {
  final AuthRepository repository;

  SignInWithMobileOTPUseCase(this.repository);

  Future<Either<AuthFailure, void>> call(String phoneNumber) {
    return repository.signInWithMobileOTP(phoneNumber);
  }
} 