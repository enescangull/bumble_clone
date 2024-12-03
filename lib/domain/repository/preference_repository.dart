import 'package:bumble_clone/core/services/preferences_service.dart';
import 'package:bumble_clone/data/models/preferences_model.dart';

class PreferenceRepository {
  final PreferencesService _service = PreferencesService();

  Future<PreferencesModel> fetchPreferences() async {
    return await _service.fetchUserPreferences();
  }

  Future<void> updatePreferences({
    required int ageMin,
    required int ageMax,
    required int distance,
    required String preferredGender,
  }) async {
    await _service.updatePreferences(
        ageMin: ageMin,
        ageMax: ageMax,
        distance: distance,
        preferredGender: preferredGender);
  }

  Future<void> onboardPreferences({
    required String preferredGender,
  }) async {
    await _service.onboardPreferences(preferredGender: preferredGender);
  }
}
