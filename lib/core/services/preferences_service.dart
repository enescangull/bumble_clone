import 'package:bumble_clone/data/models/preferences_model.dart';
import 'package:bumble_clone/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PreferencesService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<PreferencesModel> fetchUserPreferences() async {
    final currentUser = _client.auth.currentUser;

    if (currentUser == null) {
      throw Exception('Kullanıcı girişi yapılmamış');
    }

    final String userId = currentUser.id;

    final response = await _client
        .from('preferences')
        .select()
        .eq('user_id', userId)
        .maybeSingle(); // Sadece tek bir kayıt bekleniyorsa kullanılır

    if (response == null) {
      throw Exception('Preferences bulunamadı');
    }

    return PreferencesModel.fromJson(response);
  }

  Future<List<UserModel>> fetchFilteredUsers(String userId) async {
    final PreferencesModel currentUserPreferences =
        await fetchUserPreferences();
    final minDate = DateTime(
        DateTime.now().year - currentUserPreferences.ageMin,
        DateTime.now().month,
        DateTime.now().day);
    final maxDate = DateTime(
        DateTime.now().year - currentUserPreferences.ageMax,
        DateTime.now().month,
        DateTime.now().day);
    final response = await _client
        .from('users')
        .select()
        .filter('id', 'neq', userId)
        .filter('gender', 'eq', currentUserPreferences.preferredGender)
        .filter('birth_date', 'lte', minDate.toIso8601String())
        .filter('birth_date', 'gte', maxDate.toIso8601String());
    return (response as List).map((user) => UserModel.fromJson(user)).toList();
  }

  Future<void> onboardPreferences({
    required String preferredGender,
  }) async {
    final userId = _client.auth.currentUser!.id;
    try {
      await _client.from('preferences').upsert({
        'user_id': userId,
        'preferred_gender': preferredGender,
      });
    } catch (e) {
      throw Exception('Tercihler ayarlanırken hata oluştu:${e.toString()}');
    }
  }

  Future<void> updatePreferences({
    required int ageMin,
    required int ageMax,
    required int distance,
    required String preferredGender,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user != null) {
        final userId = user.id;
        await _client.from('preferences').update({
          'age_range_min': ageMin,
          'age_range_max': ageMax,
          'distance_max': distance,
          'preferred_gender': preferredGender,
        }).eq('user_id', userId);
      } else {
        throw Exception("User bulunamadı");
      }
    } catch (e) {
      throw Exception('Tercihler ayarlanırken hata oluştu:${e.toString()}');
    }
  }
}
