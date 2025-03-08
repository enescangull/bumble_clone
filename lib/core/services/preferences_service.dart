import 'package:bumble_clone/core/exceptions/app_exceptions.dart';
import 'package:bumble_clone/data/models/preferences_model.dart';
import 'package:bumble_clone/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Kullanıcı tercihlerini yöneten servis sınıfı.
///
/// Bu sınıf, kullanıcı tercihlerinin alınması, güncellenmesi ve
/// filtrelenmiş kullanıcı listesinin getirilmesi gibi tercih işlemlerini gerçekleştirir.
class PreferencesService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Kullanıcı tercihlerini getirir.
  ///
  /// Başarılı olursa [PreferencesModel] döndürür.
  /// Kullanıcı bulunamazsa veya tercihler bulunamazsa bir exception fırlatır.
  Future<PreferencesModel> fetchUserPreferences() async {
    final currentUser = _client.auth.currentUser;

    if (currentUser == null) {
      throw UserException.userNotFound();
    }

    final String userId = currentUser.id;

    try {
      final response = await _client
          .from('preferences')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        throw UserException.unknown('Tercihler bulunamadı');
      }

      return PreferencesModel.fromJson(response);
    } catch (e) {
      if (e is UserException) {
        rethrow;
      }
      throw UserException.unknown('Tercihler getirilirken hata oluştu: $e');
    }
  }

  /// Filtrelenmiş kullanıcı listesini getirir.
  ///
  /// [userId] parametresi, mevcut kullanıcının ID'sini alır.
  /// Başarılı olursa filtrelenmiş [UserModel] listesi döndürür.
  /// Başarısız olursa bir exception fırlatır.
  Future<List<UserModel>> fetchFilteredUsers(String userId) async {
    try {
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

      final swipedUsersResponse = await _client
          .from('swipes')
          .select('swiped_id')
          .eq('swiper_id', userId);
      final swipedUserIds = (swipedUsersResponse as List)
          .map((swipe) => swipe['swiped_id'] as String)
          .toList();

      // final matchesResponse = await _client
      //     .from('matches')
      //     .select()
      //     .or('user1_id.eq.$userId,user2_id.eq.$userId');
      // final matchedUserIds = (matchesResponse as List)
      //     .map<String>(
      //       (match) => match['user1_id'] == userId
      //           ? match['user2_id'] as String
      //           : match['user1_id'] as String,
      //     )
      //     .toList();

      // final filteredUserIds = [...matchedUserIds, ...swipedUserIds];
      final response = await _client
          .from('users')
          .select()
          .filter('id', 'neq', userId)
          .filter('gender', 'eq', currentUserPreferences.preferredGender)
          .filter('birth_date', 'lte', minDate.toIso8601String())
          .filter('birth_date', 'gte', maxDate.toIso8601String())
          .not('id', 'in', swipedUserIds);
      return (response as List)
          .map((user) => UserModel.fromJson(user))
          .toList();
    } catch (e) {
      if (e is UserException) {
        rethrow;
      }
      throw UserException.unknown(
          'Filtrelenmiş kullanıcılar getirilirken hata oluştu: $e');
    }
  }

  /// İlk kullanıcı tercihlerini oluşturur.
  ///
  /// [preferredGender] parametresi, tercih edilen cinsiyeti alır.
  /// Başarısız olursa bir exception fırlatır.
  Future<void> onboardPreferences({
    required String preferredGender,
  }) async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) {
      throw UserException.userNotFound();
    }

    final userId = currentUser.id;
    try {
      await _client.from('preferences').upsert({
        'user_id': userId,
        'preferred_gender': preferredGender,
      });
    } catch (e) {
      throw UserException.unknown('Tercihler ayarlanırken hata oluştu: $e');
    }
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
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw UserException.userNotFound();
      }

      final userId = user.id;
      await _client.from('preferences').update({
        'age_range_min': ageMin,
        'age_range_max': ageMax,
        'distance_max': distance,
        'preferred_gender': preferredGender,
      }).eq('user_id', userId);
    } catch (e) {
      if (e is UserException) {
        rethrow;
      }
      throw UserException.unknown('Tercihler güncellenirken hata oluştu: $e');
    }
  }
}
