import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mutual_fund_watchlist/features/authflow/data/datasources/auth_remote_data_source.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/entities/user_entity.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/repositories/auth_repository.dart';

/// Implementation of the AuthRepository interface
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<AuthFailure, UserEntity>> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userModel = await remoteDataSource.signInWithEmailAndPassword(email, password);
      return Right(userModel);
    } on AuthException catch (e) {
      if (e.message.contains('Invalid credentials')) {
        return Left(InvalidCredentialsFailure(e.message));
      }
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('Sign in error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity>> registerWithEmailAndPassword(
    String email,
    String password,
    String? name,
  ) async {
    try {
      final userModel = await remoteDataSource.registerWithEmailAndPassword(email, password, name);
      return Right(userModel);
    } on AuthException catch (e) {
      if (e.message.contains('already exists')) {
        return Left(UserExistsFailure(e.message));
      }
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('Registration error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, void>> signInWithMobileOTP(String phoneNumber) async {
    try {
      await remoteDataSource.signInWithMobileOTP(phoneNumber);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('Mobile OTP sign in error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity>> verifyOTP(String phoneNumber, String otpCode) async {
    try {
      final userModel = await remoteDataSource.verifyOTP(phoneNumber, otpCode);
      return Right(userModel);
    } on AuthException catch (e) {
      return Left(OTPVerificationFailure(e.message));
    } catch (e) {
      debugPrint('OTP verification error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      debugPrint('Sign out error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      if (userModel == null) {
        return Right(UserEntity.unauthenticated());
      }
      return Right(userModel);
    } catch (e) {
      debugPrint('Get current user error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> isUserAuthenticated() async {
    try {
      return await remoteDataSource.isUserAuthenticated();
    } catch (e) {
      debugPrint('Auth check error: $e');
      return false;
    }
  }
}
