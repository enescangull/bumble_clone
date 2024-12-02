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
    return _client.auth.currentUser!.id;
  }

  Future<void> updateAdditionalInfo({
    required String userId,
    required String name,
    required DateTime birthDate,
    required String gender,
    required String preferredGender,
    required String profilePicture,
  }) async {
    try {
      await _client.from('users').update({
        'name': name,
        'birth_date': birthDate.toIso8601String(),
        'gender': gender,
        'preferred_gender': preferredGender,
        'profile_picture': profilePicture,
      }).eq('id', userId);
    } catch (e) {
      throw Exception("Error saving user data: $e");
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
      print("image selected");
      return image.path;
    }
    return "";
  }
}
