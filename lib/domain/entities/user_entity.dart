class UserEntity {
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

  UserEntity({
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
}
