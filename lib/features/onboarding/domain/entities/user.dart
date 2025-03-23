import 'package:equatable/equatable.dart';

/// User entity representing a signed-in user
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final bool isFirstLogin;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profileImageUrl,
    required this.isFirstLogin,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phoneNumber,
        profileImageUrl,
        isFirstLogin,
        createdAt,
      ];

  /// Empty user which represents an unauthenticated user
  static final empty = User(
    id: '',
    name: '',
    email: '',
    isFirstLogin: true,
    createdAt: DateTime(1970),
  );

  /// Checks if the user is empty (unauthenticated)
  bool get isEmpty => this == empty;

  /// Checks if the user is not empty (authenticated)
  bool get isNotEmpty => this != empty;
} 