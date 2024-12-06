import 'dart:convert';

import 'package:bumble_clone/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth
        .signInWithPassword(password: password, email: email);
  }

  Future<UserModel> signUp(String email, String password) async {
    try {
      // Kullanıcı kaydı
      final response =
          await _client.auth.signUp(password: password, email: email);

      if (response.user == null) {
        throw Exception("User not created!");
      }

      // Şifre hash'ini oluştur
      final passwordHash = generatePasswordHash(password);

      // Kullanıcı bilgilerini modelle
      final userJson = {
        'id': response.user!.id, // Auth'dan gelen kullanıcı ID
        'email': email,
        'password_hash': passwordHash,
        'name': '', // Varsayılan boş string
        'profile_picture': null, // Başlangıçta boş
        'bio': null,
        'gender': null,
        'preferred_gender': null,
        'birth_date': null,
      };

      UserModel user = UserModel.fromJson(userJson);
      await _client.from('users').upsert({
        'id': user.id,
        'email': user.email,
        'password_hash': user.passwordHash
      });
      return user;
    } catch (e) {
      rethrow;
    }
  }

  String generatePasswordHash(String password) {
    final bytes = utf8.encode(password); // Şifreyi byte dizisine çevir
    final hash = sha256.convert(bytes); // SHA-256 hash oluştur
    return hash.toString(); // Hash'i string olarak döndür
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;
}
