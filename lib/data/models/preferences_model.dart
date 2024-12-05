import 'package:bumble_clone/domain/entities/preferences_entity.dart';
import 'package:equatable/equatable.dart';

class PreferencesModel extends Equatable {
  final String userId;
  final String preferredGender;
  final int ageMin;
  final int ageMax;
  final int distance;

  const PreferencesModel({
    required this.userId,
    required this.preferredGender,
    required this.ageMin,
    required this.ageMax,
    required this.distance,
  });
  factory PreferencesModel.fromJson(Map<String, dynamic> json) {
    return PreferencesModel(
      userId: json['user_id'] as String,
      ageMin: json['age_range_min'] as int,
      ageMax: json['age_range_max'] as int,
      distance: json['distance_max'] as int,
      preferredGender: json['preferred_gender'] as String,
    );
  }
  PreferencesEntity toEntity() {
    return PreferencesEntity(
      userId: userId,
      preferredGender: preferredGender,
      ageMin: ageMin,
      ageMax: ageMax,
      distance: distance,
    );
  }

  factory PreferencesModel.fromEntity(PreferencesEntity entity) {
    return PreferencesModel(
      userId: entity.userId,
      preferredGender: entity.preferredGender,
      ageMin: entity.ageMin,
      ageMax: entity.ageMax,
      distance: entity.distance,
    );
  }
  @override
  List<Object?> get props =>
      [ageMin, ageMax, distance, userId, preferredGender];
}
