import 'package:equatable/equatable.dart';

/// User entity - represents the core user business object
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  /// Empty user for uninitialized states
  static const empty = UserEntity(
    id: '',
    email: '',
  );

  /// Check if user is empty
  bool get isEmpty => this == UserEntity.empty;
  bool get isNotEmpty => !isEmpty;

  /// Display name - returns name or email if name is null
  String get displayName => name ?? email.split('@').first;

  /// User initials for avatar
  String get initials {
    if (name != null && name!.isNotEmpty) {
      final parts = name!.split(' ');
      if (parts.length >= 2) {
        return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
      }
      return name![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, email, name, avatarUrl, createdAt, updatedAt];
}
