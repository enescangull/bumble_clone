class UserEntity {
  final String id;
  final String email;
  final String passwordHash;
  String? name;
  String? profilePicture;
  String? bio;
  String? gender;

  DateTime? birthDate;

  UserEntity(
    this.name,
    this.profilePicture,
    this.gender,
    this.birthDate,
    this.bio, {
    required this.id,
    required this.email,
    required this.passwordHash,
  });
}
