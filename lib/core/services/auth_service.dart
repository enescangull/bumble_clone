import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth
        .signInWithPassword(password: password, email: email);
  }

  Future<AuthResponse> signUp(String email, String password) async {
    return await _client.auth.signUp(password: password, email: email);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;

  Future<void> createUser({
    required String id,
    required String name,
    required String email,
    required String passwordHash,
    required String gender,
    required String preferredGender,
    required DateTime birthDate,
  }) async {
    try {
      final response = await _client.from('users').insert({
        'id': id,
        'name': name,
        'email': email,
        'passwordHash': passwordHash,
        'gender': gender,
        'preferredGender': preferredGender,
        'birthDate': birthDate.toIso8601String(),
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
