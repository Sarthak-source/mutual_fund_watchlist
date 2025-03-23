import 'package:mutual_fund_watchlist/features/authflow/domain/entities/user_entity.dart';

/// User model that extends the UserEntity and is used for data layer operations
class UserModel extends UserEntity {
  const UserModel({
    required String id,
    String? email,
    String? name,
    bool isAuthenticated = false,
  }) : super(
          id: id,
          email: email,
          name: name,
          isAuthenticated: isAuthenticated,
        );

  /// Factory method to create a UserModel from Supabase user data
  factory UserModel.fromSupabase(Map<String, dynamic> data, {bool isAuthenticated = true}) {
    return UserModel(
      id: data['id'] ?? '',
      email: data['email'],
      name: data['user_metadata']?['name'],
      isAuthenticated: isAuthenticated,
    );
  }

  /// Factory to create a UserModel from a UserEntity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      isAuthenticated: entity.isAuthenticated,
    );
  }

  /// Convert to a Map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'isAuthenticated': isAuthenticated,
    };
  }

  /// Create a model from stored JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'],
      name: json['name'],
      isAuthenticated: json['isAuthenticated'] ?? false,
    );
  }
}
