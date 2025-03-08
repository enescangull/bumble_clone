import 'dart:io';

import 'package:bumble_clone/core/exceptions/app_exceptions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:bumble_clone/data/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../common/env.dart';

/// Kullanıcı işlemlerini gerçekleştiren servis sınıfı.
///
/// Bu sınıf, kullanıcı bilgilerinin alınması, güncellenmesi, silinmesi ve
/// konum bilgilerinin güncellenmesi gibi kullanıcı ile ilgili işlemleri gerçekleştirir.
class UserService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Tüm kullanıcıları getirir.
  ///
  /// Başarılı olursa [UserModel] listesi döndürür.
  /// Başarısız olursa bir exception fırlatır.
  Future<List<UserModel>?> fetchUsers() async {
    try {
      final response = await _client.from('users').select();
      return (response as List)
          .map((user) => UserModel.fromJson(user))
          .toList();
    } catch (e) {
      throw UserException.unknown('Kullanıcılar getirilirken hata oluştu: $e');
    }
  }

  /// Mevcut kullanıcının ID'sini döndürür.
  ///
  /// Kullanıcı oturum açmamışsa bir [UserException] fırlatır.
  String getUserId() {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) {
      throw UserException.userNotFound();
    }
    return currentUser.id;
  }

  /// Belirli bir kullanıcının bilgilerini getirir.
  ///
  /// [userId] parametresi, bilgileri getirilecek kullanıcının ID'sini alır.
  /// Başarılı olursa [UserModel] döndürür.
  /// Kullanıcı bulunamazsa bir [UserException] fırlatır.
  Future<UserModel> getUserById(String userId) async {
    try {
      final response =
          await _client.from('users').select().eq('id', userId).maybeSingle();

      if (response == null) {
        throw UserException.userNotFound();
      }

      return UserModel.fromJson(response);
    } catch (e) {
      if (e is UserException) {
        rethrow;
      }
      throw UserException.unknown(
          'Kullanıcı bilgileri getirilirken hata oluştu: $e');
    }
  }

  /// Kullanıcı bilgilerini günceller.
  ///
  /// [name], [birthDate], [gender] ve [profilePicture] parametrelerini alarak
  /// kullanıcı bilgilerini günceller.
  /// Başarısız olursa bir [UserException] fırlatır.
  Future<void> updateAdditionalInfo({
    required String name,
    required DateTime birthDate,
    required String gender,
    required String profilePicture,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw UserException.userNotFound();
    }

    try {
      await _client.from('users').update({
        'name': name,
        'birth_date': birthDate.toIso8601String(),
        'gender': gender,
        'profile_picture': profilePicture,
      }).eq('id', userId);
    } catch (e) {
      throw UserException.profileUpdateFailed();
    }
  }

  /// Kullanıcı profilini düzenler.
  ///
  /// [profilePicture] ve [bio] parametrelerini alarak kullanıcı profilini günceller.
  /// Başarısız olursa bir [UserException] fırlatır.
  Future<void> editProfile(String? profilePicture, String? bio) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw UserException.userNotFound();
    }

    try {
      await _client.from('users').update({
        'bio': bio,
        'profile_picture': profilePicture,
      }).eq('id', userId);
    } catch (e) {
      throw UserException.profileUpdateFailed();
    }
  }

  /// Kullanıcı hesabını siler.
  ///
  /// Başarısız olursa bir [UserException] fırlatır.
  Future<void> deleteAccount() async {
    final authId = _client.auth.currentUser?.id;
    final userId = getAuthenticatedUser();
    if (authId == null) {
      throw UserException.userNotFound();
    }

    try {
      await http.delete(
          Uri.parse('${SupaBase.supabaseUrl}/auth/v1/admin/users/$authId'),
          headers: {
            'apikey': SupaBase.supabaseSecretKey,
            'Authorization': 'Bearer ${SupaBase.supabaseSecretKey}',
          });
      await _client.from('users').delete().eq('id', userId);
    } catch (e) {
      throw UserException.unknown('Hesap silinirken hata oluştu: $e');
    }
  }

  /// Oturum açmış kullanıcının bilgilerini getirir.
  ///
  /// Başarılı olursa [UserModel] döndürür.
  /// Kullanıcı bulunamazsa bir [UserException] fırlatır.
  Future<UserModel?> getAuthenticatedUser() async {
    final currentUser = _client.auth.currentUser;

    if (currentUser == null) {
      return null; // Kullanıcı oturum açmamışsa null döndür
    }

    final String userId = currentUser.id;

    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle(); // Sadece tek bir kayıt bekleniyorsa kullanılır
      if (response == null) {
        throw UserException.userNotFound();
      }

      return UserModel.fromJson(response);
    } catch (e) {
      if (e is UserException) {
        rethrow;
      }
      throw UserException.unknown(
          'Kullanıcı bilgileri getirilirken hata oluştu: $e');
    }
  }

  /// Mevcut konumu getirir.
  ///
  /// Başarılı olursa [Position] döndürür.
  /// Konum servisi etkin değilse veya izin verilmemişse null döndürür.
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission? permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return Geolocator.getCurrentPosition();
  }

  /// Kullanıcının konum bilgilerini günceller.
  ///
  /// Başarısız olursa bir [UserException] fırlatır.
  Future<void> updateLocation() async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) {
      throw UserException.userNotFound();
    }

    final userId = currentUser.id;
    try {
      Position? position = await getCurrentLocation();
      if (position != null) {
        await _client.from('users').update({
          'lat': position.latitude.toString(),
          'long': position.longitude.toString(),
        }).eq('id', userId);
      } else {
        throw UserException.locationUpdateFailed();
      }
    } catch (e) {
      if (e is UserException) {
        rethrow;
      }
      throw UserException.locationUpdateFailed();
    }
  }

  /// Profil fotoğrafını yükler.
  ///
  /// [imagePath] parametresi, yüklenecek fotoğrafın yolunu alır.
  /// Başarılı olursa fotoğrafın URL'sini döndürür.
  /// Başarısız olursa null döndürür.
  Future<String?> uploadProfilePicture(String imagePath) async {
    File file = File(imagePath);
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      await _client.storage.from('profile_pictures').upload(fileName, file);

      final publicUrl =
          _client.storage.from('profile_pictures').getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      return null;
    }
  }

  /// Kullanıcının yaşını hesaplar.
  ///
  /// [birthDate] parametresi, kullanıcının doğum tarihini alır.
  /// Kullanıcının yaşını döndürür.
  int calculateAge(DateTime birthDate) {
    final currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;

    // Eğer henüz doğum günü gelmediyse, yaşı bir azaltırız
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  /// Galeriden bir resim seçer.
  ///
  /// Başarılı olursa seçilen resmin yolunu döndürür.
  /// Resim seçilmezse boş string döndürür.
  Future<String> pickImage() async {
    final ImagePicker picker = ImagePicker();

    //pick from gallery
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image.path;
    }
    return "";
  }
}
