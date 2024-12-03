class PreferencesEntity {
  final String userId;
  final String preferredGender;
  final int ageMin;
  final int ageMax;
  final int distance;

  PreferencesEntity({
    required this.userId,
    required this.preferredGender,
    required this.ageMin,
    required this.ageMax,
    required this.distance,
  });
}
