import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/entities/user_entity.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/repositories/auth_repository.dart';

/// Parameters for registration
class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String? name;

  const RegisterParams({
    required this.email,
    required this.password,
    this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

/// Register use case for email and password authentication
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  /// Execute the registration use case
  Future<Either<AuthFailure, UserEntity>> call(RegisterParams params) {
    return repository.registerWithEmailAndPassword(
      params.email,
      params.password,
      params.name,
    );
  }
} 