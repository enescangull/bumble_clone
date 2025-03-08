import 'package:bumble_clone/core/exceptions/app_exceptions.dart';
import 'package:bumble_clone/core/services/supabase_service.dart';
import 'package:bumble_clone/data/models/user_model.dart';

/// Kaydırma işlemlerini yöneten servis sınıfı.
///
/// Bu sınıf, kullanıcıların diğer kullanıcıları beğenme, beğenmeme ve
/// eşleşme kontrolü gibi kaydırma işlemlerini gerçekleştirir.
class SwipeService {
  final _client = SupabaseService.instance.client;

  /// Bir kullanıcıyı beğenir.
  ///
  /// [userId] parametresi, beğenilen kullanıcının ID'sini alır.
  /// Başarısız olursa bir exception fırlatır.
  Future<bool> likeUser(String userId) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw UserException.userNotFound();
      }
      await _client.from('swipes').upsert({
        'swiper_id': currentUser.id,
        'swiped_id': userId,
        'action': 'like',
      });
      return await checkForMatch(userId);
    } catch (e) {
      if (e is UserException) {
        rethrow;
      }
      throw UserException.unknown('Kullanıcı beğenilirken hata oluştu: $e');
    }
  }

  /// Bir kullanıcıyı beğenmez.
  ///
  /// [userId] parametresi, beğenilmeyen kullanıcının ID'sini alır.
  /// Başarısız olursa bir exception fırlatır.
  Future<void> dislikeUser(String userId) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw UserException.userNotFound();
      }

      final response = await _client
          .from('swipes')
          .select()
          .eq('swiped_id', currentUser.id)
          .eq('swiper_id', userId)
          .eq('action', 'like');

      if (response.isNotEmpty) {
        await _client
            .from('swipes')
            .delete()
            .eq('swiped_id', currentUser.id)
            .eq('swiper_id', userId)
            .eq('action', 'like');
      }

      await _client.from('swipes').upsert({
        'swiper_id': currentUser.id,
        'swiped_id': userId,
        'action': 'dislike',
      });
    } catch (e) {
      if (e is UserException) {
        rethrow;
      }
      throw UserException.unknown('Kullanıcı beğenilmezken hata oluştu: $e');
    }
  }

  /// Kullanıcıyı beğenen kullanıcıları getirir.
  ///
  /// [userId] parametresi, mevcut kullanıcının ID'sini alır.
  /// Başarılı olursa kullanıcıyı beğenen [UserModel] listesi döndürür.
  /// Başarısız olursa bir exception fırlatır.
  Future<List<UserModel>> getUsersWhoLikedYou(String userId) async {
    try {
      final response = await _client
          .from('swipes')
          .select('swiper_id')
          .eq('swiped_id', userId)
          .eq('action', 'like');

      final likedUserIds = (response as List)
          .map((swipe) => swipe['swiper_id'] as String)
          .toList();

      if (likedUserIds.isEmpty) {
        return [];
      }

      final usersResponse =
          await _client.from('users').select().inFilter('id', likedUserIds);

      return (usersResponse as List)
          .map((user) => UserModel.fromJson(user))
          .toList();
    } catch (e) {
      throw UserException.unknown(
          'Beğenen kullanıcılar getirilirken hata oluştu: $e');
    }
  }

  /// Eşleşme kontrolü yapar.
  ///
  /// [userId] parametresi, kontrol edilecek kullanıcının ID'sini alır.
  /// Eğer karşılıklı beğeni varsa, eşleşme oluşturur.
  /// Başarısız olursa bir exception fırlatır.
  Future<bool> checkForMatch(String userId) async {
    bool isMatched = false;
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw UserException.userNotFound();
      }

      final currentUserId = currentUser.id;

      // Karşı kullanıcı kullanıcıyı beğenmiş mi kontrol et
      final response = await _client
          .from('swipes')
          .select()
          .eq('swiper_id', userId)
          .eq('swiped_id', currentUserId)
          .eq('action', 'like');

      if (response.isNotEmpty) {
        // Yeni eşleşme oluştur
        await _client.from('matches').insert({
          'user1_id': currentUserId,
          'user2_id': userId,
          'matched_at': DateTime.now().toIso8601String(),
        });
        isMatched = true;

        // Swipe kaydını sil
        await _client
            .from('swipes')
            .delete()
            .eq('swiper_id', userId)
            .eq('swiped_id', currentUserId)
            .eq('action', 'like');
        return isMatched;
      }
      return false;
    } catch (e) {
      if (e is UserException) {
        rethrow;
      }
      throw UserException.unknown(
          'Eşleşme kontrolü yapılırken hata oluştu: $e');
    }
  }
}
