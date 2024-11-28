import 'package:bumble_clone/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<UserModel>?> fetchUsers() async {
    final response = await _client.from('users').select();
    return (response as List).map((user) => UserModel.fromJson(user)).toList();
  }

  Future<void> updateUser(Map<String, dynamic> profileData) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }
      await _client.from('users').update(profileData).eq('id', currentUser.id);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> getAuthenticatedUser() async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('None authenticated user found.');
      }
      final response =
          await _client.from('users').select().eq('id', currentUser.id);
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception(e);
    }
  }
}
