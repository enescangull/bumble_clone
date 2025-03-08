import 'package:bumble_clone/core/services/auth_service.dart';
import 'package:bumble_clone/data/models/user_model.dart';

/// Kimlik doğrulama işlemlerini yöneten repository sınıfı.
///
/// Bu sınıf, kullanıcı girişi, kaydı ve çıkışı gibi kimlik doğrulama
/// işlemlerini yönetir ve AuthService ile iletişim kurar.
class AuthRepository {
  final AuthService _authService;

  /// AuthRepository sınıfının constructor'ı.
  ///
  /// [_authService] parametresi, kimlik doğrulama işlemlerini gerçekleştiren servisi alır.
  AuthRepository(this._authService);

  /// Kullanıcı girişi yapar.
  ///
  /// [email] ve [password] parametrelerini alarak kullanıcı girişi yapar.
  /// Başarısız olursa bir exception fırlatır.
  Future<void> login(String email, String password) async {
    await _authService.signIn(email, password);
  }

  /// Yeni kullanıcı kaydı yapar.
  ///
  /// [email] ve [password] parametrelerini alarak yeni kullanıcı kaydı yapar.
  /// Başarılı olursa oluşturulan [UserModel] nesnesini döndürür.
  /// Başarısız olursa bir exception fırlatır.
  Future<UserModel> register(String email, String password) async {
    return await _authService.signUp(email, password);
  }

  /// Kullanıcı çıkışı yapar.
  ///
  /// Mevcut oturumu sonlandırır.
  /// Başarısız olursa bir exception fırlatır.
  Future<void> logOut() async {
    await _authService.signOut();
  }

  /// Mevcut kullanıcının e-posta adresini döndürür.
  ///
  /// Kullanıcı oturum açmamışsa null döndürür.
  String? getCurrentUserEmail() {
    return _authService.currentUser?.email;
  }
}
