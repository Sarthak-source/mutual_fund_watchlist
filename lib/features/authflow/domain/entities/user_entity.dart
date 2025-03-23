import 'package:equatable/equatable.dart';

/// Entity representing a user of the application
class UserEntity extends Equatable {
  final String id;
  final String? email;
  final String? name;
  final bool isAuthenticated;

  const UserEntity({
    required this.id,
    this.email,
    this.name,
    this.isAuthenticated = false,
  });

  /// Factory method to create an unauthenticated user
  factory UserEntity.unauthenticated() => const UserEntity(
        id: '',
        isAuthenticated: false,
      );

  @override
  List<Object?> get props => [id, email, name, isAuthenticated];
}
