import 'package:bumble_clone/core/exceptions/app_exceptions.dart';
import 'package:bumble_clone/core/services/user_service.dart';
import 'package:bumble_clone/data/models/user_model.dart';

/// Kullanıcı işlemlerini yöneten repository sınıfı.
///
/// Bu sınıf, kullanıcı bilgilerinin alınması, güncellenmesi ve silinmesi gibi
/// kullanıcı ile ilgili işlemleri yönetir ve UserService ile iletişim kurar.
class IUserRepository {
  final UserService _service;

  /// IUserRepository sınıfının constructor'ı.
  ///
  /// [_service] parametresi, kullanıcı işlemlerini gerçekleştiren servisi alır.
  IUserRepository(this._service);

  /// Tüm kullanıcıları getirir.
  ///
  /// Başarılı olursa [UserModel] listesi döndürür.
  /// Başarısız olursa null döndürür.
  Future<List<UserModel>?> call() async {
    return await _service.fetchUsers();
  }

  /// Mevcut kullanıcının ID'sini döndürür.
  ///
  /// Kullanıcı oturum açmamışsa hata fırlatır.
  String getUserId() {
    return _service.getUserId();
  }

  /// Kullanıcının konumunu günceller.
  ///
  /// Başarısız olursa bir exception fırlatır.
  Future<void> updateLocation() async {
    await _service.updateLocation();
  }

  /// Kullanıcı bilgilerini günceller.
  ///
  /// [name], [birthDate], [gender] ve [profilePicture] parametrelerini alarak
  /// kullanıcı bilgilerini günceller.
  /// Başarısız olursa bir exception fırlatır.
  Future<void> updateUser({
    required String name,
    required DateTime birthDate,
    required String gender,
    required String profilePicture,
  }) async {
    await _service.updateAdditionalInfo(
      name: name,
      birthDate: birthDate,
      gender: gender,
      profilePicture: profilePicture,
    );
  }

  /// Kullanıcı hesabını siler.
  ///
  /// Başarısız olursa bir exception fırlatır.
  Future<void> deleteAccount() async {
    _service.deleteAccount();
  }

  /// Oturum açmış kullanıcının bilgilerini getirir.
  ///
  /// Başarılı olursa [UserModel] döndürür.
  /// Kullanıcı bulunamazsa bir [UserException] fırlatır.
  Future<UserModel> getAuthenticatedUser() async {
    final user = await _service.getAuthenticatedUser();
    if (user == null) {
      throw UserException.userNotFound();
    }
    return user;
  }

  /// Kullanıcının yaşını hesaplar.
  ///
  /// [birthDate] parametresini alarak kullanıcının yaşını hesaplar ve döndürür.
  int age(DateTime birthDate) {
    return _service.calculateAge(birthDate);
  }
}
