import 'dart:io';

import 'package:bumble_clone/core/services/preferences_service.dart';
import 'package:bumble_clone/data/models/preferences_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:bumble_clone/data/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../common/env.dart';

class UserService {
  final SupabaseClient _client = Supabase.instance.client;
  final PreferencesService _preferencesService = PreferencesService();

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

  Future<void> deleteAccount() async {
    final authId = _client.auth.currentUser!.id;
    await http.delete(
        Uri.parse('${SupaBase.supabaseUrl}/auth/v1/admin/users/$authId'),
        headers: {
          'apikey': SupaBase.supabaseSecretKey,
          'Authorization': 'Bearer ${SupaBase.supabaseSecretKey}',
        });
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

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission? permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == null) {
      permission = await Geolocator.requestPermission();
    }
    return Geolocator.getCurrentPosition();
  }

  Future<void> updateLocation() async {
    final currentUser = _client.auth.currentUser;
    final userId = currentUser!.id;
    Position? position = await getCurrentLocation();
    if (position != null) {
      await _client.from('users').update({
        'lat': position.latitude.toString(),
        'long': position.longitude.toString(),
      }).eq('id', userId);
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
      return null;
    }
  }

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
