class UserEntity {
  final String id;
  final String name;
  final String email;
  final String passwordHash;
  final String profilePicture;

  UserEntity(
      {required this.id,
      required this.name,
      required this.email,
      required this.passwordHash,
      required this.profilePicture});

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      passwordHash: json['passwordHash'],
      profilePicture: json['profilePicture'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': passwordHash,
    };
  }
}
