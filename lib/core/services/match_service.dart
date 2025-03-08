import 'package:bumble_clone/data/models/match_model.dart';
import 'package:bumble_clone/core/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/user_model.dart';

class MatchService {
  final SupabaseClient _client = Supabase.instance.client;
  final UserService _userService = UserService();

  Future<List<MatchModel>?> fetchMatches() async {
    final userId = _userService.getUserId();
    final response = await _client
        .from('matches')
        .select()
        .or('user1_id.eq.$userId,user2_id.eq.$userId');
    return (response as List)
        .map((match) => MatchModel.fromJson(match))
        .toList();
  }

  Future<UserModel> fetchMatchedUser(MatchModel match) async {
    final userResponse = await _client
        .from('users')
        .select()
        .eq(
            'id',
            match.user1Id == _userService.getUserId()
                ? match.user2Id
                : match.user1Id)
        .single();
    return UserModel.fromJson(userResponse);
  }

  Future<bool> hasMessages(String matchId) async {
    final response = await _client
        .from('messages')
        .select()
        .eq('match_id', matchId)
        .limit(1);

    return response.isNotEmpty;
  }

  /// Bir eşleşmeyi siler ve ilgili mesajları temizler.
  ///
  /// [matchId] parametresi, silinecek eşleşmenin ID'sini alır.
  /// Başarılı olursa true, başarısız olursa false döndürür.
  Future<bool> deleteMatch(String matchId) async {
    try {
      // Önce eşleşmeye ait tüm mesajları sil
      await _client.from('messages').delete().eq('match_id', matchId);

      // Sonra eşleşmeyi sil
      await _client.from('matches').delete().eq('id', matchId);

      print('Match and related messages deleted successfully: $matchId');
      return true;
    } catch (e) {
      print('Error deleting match: $e');
      return false;
    }
  }
}
