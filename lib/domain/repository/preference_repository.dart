import 'package:bumble_clone/core/services/preferences_service.dart';
import 'package:bumble_clone/data/models/preferences_model.dart';

/// Kullanıcı tercihlerini yöneten repository sınıfı.
///
/// Bu sınıf, kullanıcı tercihlerinin alınması ve güncellenmesi gibi
/// tercih işlemlerini yönetir ve PreferencesService ile iletişim kurar.
class PreferenceRepository {
  final PreferencesService _service;

  /// PreferenceRepository sınıfının constructor'ı.
  ///
  /// [_service] parametresi, tercih işlemlerini gerçekleştiren servisi alır.
  PreferenceRepository(this._service);

  /// Kullanıcı tercihlerini getirir.
  ///
  /// Başarılı olursa [PreferencesModel] döndürür.
  /// Başarısız olursa bir exception fırlatır.
  Future<PreferencesModel> fetchPreferences() async {
    return await _service.fetchUserPreferences();
  }

  /// Kullanıcı tercihlerini günceller.
  ///
  /// [ageMin], [ageMax], [distance] ve [preferredGender] parametrelerini alarak
  /// kullanıcı tercihlerini günceller.
  /// Başarısız olursa bir exception fırlatır.
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

  /// İlk kullanıcı tercihlerini oluşturur.
  ///
  /// [preferredGender] parametresini alarak ilk kullanıcı tercihlerini oluşturur.
  /// Başarısız olursa bir exception fırlatır.
  Future<void> onboardPreferences({
    required String preferredGender,
  }) async {
    await _service.onboardPreferences(preferredGender: preferredGender);
  }
}
