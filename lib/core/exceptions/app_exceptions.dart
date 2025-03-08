/// Uygulama genelinde kullanılacak temel exception sınıfı
abstract class AppException implements Exception {
  final String message;
  final String code;

  AppException(this.message, this.code);

  @override
  String toString() => '$runtimeType: $message (code: $code)';
}

/// Kimlik doğrulama ile ilgili hatalar için exception sınıfı
class AuthException extends AppException {
  AuthException(String message, String code) : super(message, code);

  /// Şifre eşleşmediğinde kullanılacak factory constructor
  factory AuthException.passwordMismatch() {
    return AuthException('Şifreler eşleşmiyor', 'password_mismatch');
  }

  /// Kullanıcı bulunamadığında kullanılacak factory constructor
  factory AuthException.userNotFound() {
    return AuthException('Kullanıcı bulunamadı', 'user_not_found');
  }

  /// Geçersiz kimlik bilgileri için kullanılacak factory constructor
  factory AuthException.invalidCredentials() {
    return AuthException('Geçersiz e-posta veya şifre', 'invalid_credentials');
  }

  /// Veritabanı hatası için kullanılacak factory constructor
  factory AuthException.databaseError(String originalCode) {
    return AuthException('Veritabanı hatası', originalCode);
  }

  /// Bilinmeyen hatalar için kullanılacak factory constructor
  factory AuthException.unknown(String message) {
    return AuthException(message, 'unknown');
  }
}

/// Kullanıcı işlemleri ile ilgili hatalar için exception sınıfı
class UserException extends AppException {
  UserException(String message, String code) : super(message, code);

  /// Kullanıcı bulunamadığında kullanılacak factory constructor
  factory UserException.userNotFound() {
    return UserException('Kullanıcı bulunamadı', 'user_not_found');
  }

  /// Konum güncellenemediğinde kullanılacak factory constructor
  factory UserException.locationUpdateFailed() {
    return UserException('Konum güncellenemedi', 'location_update_failed');
  }

  /// Profil güncellenemediğinde kullanılacak factory constructor
  factory UserException.profileUpdateFailed() {
    return UserException('Profil güncellenemedi', 'profile_update_failed');
  }

  /// Bilinmeyen hatalar için kullanılacak factory constructor
  factory UserException.unknown(String message) {
    return UserException(message, 'unknown');
  }
}

/// Ağ işlemleri ile ilgili hatalar için exception sınıfı
class NetworkException extends AppException {
  NetworkException(String message, String code) : super(message, code);

  /// Bağlantı hatası için kullanılacak factory constructor
  factory NetworkException.connectionError() {
    return NetworkException(
        'İnternet bağlantısı bulunamadı', 'connection_error');
  }

  /// Zaman aşımı hatası için kullanılacak factory constructor
  factory NetworkException.timeoutError() {
    return NetworkException('İstek zaman aşımına uğradı', 'timeout_error');
  }

  /// Sunucu hatası için kullanılacak factory constructor
  factory NetworkException.serverError() {
    return NetworkException('Sunucu hatası', 'server_error');
  }

  /// Bilinmeyen hatalar için kullanılacak factory constructor
  factory NetworkException.unknown(String message) {
    return NetworkException(message, 'unknown');
  }
}
