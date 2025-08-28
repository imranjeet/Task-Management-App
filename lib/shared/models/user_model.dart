import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    required this.createdAt,
    required this.lastLoginAt,
  });

  factory UserModel.create({
    required String id,
    required String email,
    String? displayName,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: id,
      email: email,
      displayName: displayName,
      createdAt: now,
      lastLoginAt: now,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastLoginAt': lastLoginAt.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final now = DateTime.now();
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      createdAt: map['createdAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : now,
      lastLoginAt: map['lastLoginAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['lastLoginAt'])
          : now,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        createdAt,
        lastLoginAt,
      ];
}
