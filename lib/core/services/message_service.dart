import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bumble_clone/data/models/message_model.dart';

class MessageService {
  final SupabaseClient _client = Supabase.instance.client;

  Stream<List<MessageModel>> getMessages(String matchId) {
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('match_id', matchId)
        .order('created_at', ascending: true)
        .map((data) => data
            .map<MessageModel>((message) => MessageModel.fromJson(message))
            .toList());
  }

  Future<void> sendMessage(
      String matchId, String senderId, String content) async {
    await _client.from('messages').insert({
      'match_id': matchId,
      'sender_id': senderId,
      'content': content,
    });
  }

  Stream<MessageModel?> getLastMessageStream(String matchId) {
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('match_id', matchId)
        .order('created_at', ascending: false)
        .limit(1)
        .map((messages) =>
            messages.isNotEmpty ? MessageModel.fromJson(messages.first) : null);
  }
}
