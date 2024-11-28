import 'package:bumble_clone/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String passwordHash;
  final String profilePicture;
  final String bio;
  final String gender;
  final String preferredGender;
  final DateTime birthDate;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.profilePicture,
    required this.bio,
    required this.gender,
    required this.preferredGender,
    required this.birthDate,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      passwordHash: json['passwordHash'] as String,
      profilePicture: json['profilePicture'] as String,
      bio: json['bio'] as String,
      gender: json['gender'] as String,
      preferredGender: json['gender'] as String,
      birthDate: json['birthDate'],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': passwordHash,
      'profilePicture': profilePicture,
      'bio': bio,
      'gender': gender,
      'preferredGender': preferredGender,
      'birthDate': birthDate,
      'createdAt': createdAt,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      passwordHash: passwordHash,
      profilePicture: profilePicture,
      bio: bio,
      gender: gender,
      preferredGender: preferredGender,
      birthDate: birthDate,
      createdAt: createdAt,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      passwordHash: entity.passwordHash,
      profilePicture: entity.profilePicture,
      bio: entity.bio,
      gender: entity.gender,
      preferredGender: entity.preferredGender,
      birthDate: entity.birthDate,
      createdAt: entity.createdAt,
    );
  }
}
