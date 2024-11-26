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
}
