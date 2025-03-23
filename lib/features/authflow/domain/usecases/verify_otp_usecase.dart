// This file can be deleted as we've replaced phone OTP verification 
// with email/password authentication through Supabase. 

import 'package:dartz/dartz.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/entities/user_entity.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/repositories/auth_repository.dart';

class VerifyOTPUseCase {
  final AuthRepository repository;

  VerifyOTPUseCase(this.repository);

  Future<Either<AuthFailure, UserEntity>> call(String phoneNumber, String otpCode) {
    return repository.verifyOTP(phoneNumber, otpCode);
  }
} 