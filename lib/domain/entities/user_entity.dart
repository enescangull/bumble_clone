class UserEntity {
  final String id;
  final String name;
  final String email;
  final String password;
  final String profilePicture;

  UserEntity(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.profilePicture});

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      profilePicture: map['profilePicture'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
