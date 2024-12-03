import 'package:bumble_clone/domain/entities/user_entity.dart';

class UserModel {
  String id;
  String? name;
  final String email;
  final String passwordHash;
  String? profilePicture; // Opsiyonel alan
  String? bio; // Opsiyonel alan
  String? gender; // Opsiyonel alan // Opsiyonel alan
  DateTime? birthDate; // Nullable alan

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.profilePicture,
    this.bio,
    this.gender,
    this.birthDate,
  });

  /// JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password_hash': passwordHash,
      'name': name,
      'profile_picture': profilePicture,
      'bio': bio,
      'gender': gender,

      'birth_date': birthDate?.toIso8601String(), // Null kontrolü
    };
  }

  /// JSON'dan Model'e dönüştürme
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      passwordHash: json['password_hash'] as String,
      name: json['name'] as String? ?? '', // Varsayılan boş string
      profilePicture: json['profile_picture'] as String?,
      bio: json['bio'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'] as String)
          : null,
    );
  }

  /// Entity'ye dönüştürme
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name,
      profilePicture,
      bio,
      birthDate,
      gender,
      email: email,
      passwordHash: passwordHash,
    );
  }

  /// Entity'den Model'e dönüştürme
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      passwordHash: entity.passwordHash,
      profilePicture: entity.profilePicture,
      bio: entity.bio,
      gender: entity.gender,
      birthDate: entity.birthDate,
    );
  }
}
