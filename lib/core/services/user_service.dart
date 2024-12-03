import 'dart:io';

import 'package:bumble_clone/data/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<UserModel>?> fetchUsers() async {
    final response = await _client.from('users').select();
    return (response as List).map((user) => UserModel.fromJson(user)).toList();
  }

  String getUserId() {
    final String userId = _client.auth.currentUser!.id;
    return userId;
  }

  Future<void> updateAdditionalInfo({
    required String name,
    required DateTime birthDate,
    required String gender,
    required String profilePicture,
  }) async {
    final userId = _client.auth.currentUser!.id;
    try {
      await _client.from('users').update({
        'name': name,
        'birth_date': birthDate.toIso8601String(),
        'gender': gender,
        'profile_picture': profilePicture,
      }).eq('id', userId);
    } catch (e) {
      throw Exception("Error saving user data: $e");
    }
  }

  Future<UserModel> getAuthenticatedUser() async {
    final currentUser = _client.auth.currentUser;

    if (currentUser == null) {
      throw Exception('None authenticated user');
    }

    final String userId = currentUser.id;

    final response = await _client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle(); // Sadece tek bir kayıt bekleniyorsa kullanılır
    if (response == null) {
      throw Exception('User not found');
    }

    return UserModel.fromJson(response);
  }

  Future<String?> uploadProfilePicture(String imagePath) async {
    File file = File(imagePath);
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      await _client.storage.from('profile_pictures').upload(fileName, file);

      final publicUrl =
          _client.storage.from('profile_pictures').getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

  int calculateAge(DateTime birthdate) {
    final currentDate = DateTime.now();
    int age = currentDate.year - birthdate.year;

    // Eğer henüz doğum günü gelmediyse, yaşı bir azaltırız
    if (currentDate.month < birthdate.month ||
        (currentDate.month == birthdate.month &&
            currentDate.day < birthdate.day)) {
      age--;
    }

    return age;
  }

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
