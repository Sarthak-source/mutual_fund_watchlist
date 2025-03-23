import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/entities/user_entity.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/repositories/auth_repository.dart';

/// Parameters for sign in
class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Sign in use case for email and password authentication
class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  /// Execute the sign in use case
  Future<Either<AuthFailure, UserEntity>> call(SignInParams params) {
    return repository.signInWithEmailAndPassword(
      params.email,
      params.password,
    );
  }
} 