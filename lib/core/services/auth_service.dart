import 'dart:convert';

import 'package:bumble_clone/core/exceptions/app_exceptions.dart'
    as app_exceptions;
import 'package:bumble_clone/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';

/// Kimlik doğrulama işlemlerini gerçekleştiren servis sınıfı.
///
/// Bu sınıf, Supabase ile iletişim kurarak kullanıcı girişi, kaydı ve çıkışı
/// gibi kimlik doğrulama işlemlerini gerçekleştirir.
class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Kullanıcı girişi yapar.
  ///
  /// [email] ve [password] parametrelerini alarak kullanıcı girişi yapar.
  /// Başarılı olursa [AuthResponse] döndürür.
  /// Başarısız olursa bir [app_exceptions.AuthException] fırlatır.
  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final response = await _client.auth
          .signInWithPassword(password: password, email: email);
      return response;
    } on app_exceptions.AuthException {
      rethrow;
    } catch (e) {
      if (e is app_exceptions.AuthException) {
        rethrow;
      } else if (e is PostgrestException) {
        throw app_exceptions.AuthException.databaseError(
            e.code ?? 'unknown_db_error');
      } else if (e.toString().contains('Invalid login credentials')) {
        throw app_exceptions.AuthException.invalidCredentials();
      } else {
        throw app_exceptions.AuthException.unknown(e.toString());
      }
    }
  }

  /// Yeni kullanıcı kaydı yapar.
  ///
  /// [email] ve [password] parametrelerini alarak yeni kullanıcı kaydı yapar.
  /// Başarılı olursa oluşturulan [UserModel] nesnesini döndürür.
  /// Başarısız olursa bir [app_exceptions.AuthException] fırlatır.
  Future<UserModel> signUp(String email, String password) async {
    try {
      // Kullanıcı kaydı
      final response =
          await _client.auth.signUp(password: password, email: email);

      if (response.user == null) {
        throw app_exceptions.AuthException.userNotFound();
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
    } on app_exceptions.AuthException {
      rethrow;
    } catch (e) {
      if (e is PostgrestException) {
        throw app_exceptions.AuthException.databaseError(
            e.code ?? 'unknown_db_error');
      } else {
        throw app_exceptions.AuthException.unknown(e.toString());
      }
    }
  }

  /// Şifre hash'i oluşturur.
  ///
  /// [password] parametresini alarak SHA-256 hash'i oluşturur ve string olarak döndürür.
  String generatePasswordHash(String password) {
    final bytes = utf8.encode(password); // Şifreyi byte dizisine çevir
    final hash = sha256.convert(bytes); // SHA-256 hash oluştur
    return hash.toString(); // Hash'i string olarak döndür
  }

  /// Kullanıcı çıkışı yapar.
  ///
  /// Mevcut oturumu sonlandırır.
  /// Başarısız olursa bir [app_exceptions.AuthException] fırlatır.
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw app_exceptions.AuthException.unknown(e.toString());
    }
  }

  /// Mevcut kullanıcıyı döndürür.
  ///
  /// Kullanıcı oturum açmamışsa null döndürür.
  User? get currentUser => _client.auth.currentUser;
}
