abstract class FilterEvent {}

class UpdatePreferences extends FilterEvent {
  final int ageMin;
  final int ageMax;
  final int distance;
  final String preferredGender;

  UpdatePreferences(
      {required this.ageMin,
      required this.ageMax,
      required this.distance,
      required this.preferredGender});
}

class GetFilterParameters extends FilterEvent {}
