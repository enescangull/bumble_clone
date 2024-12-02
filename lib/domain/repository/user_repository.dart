import 'package:bumble_clone/core/services/user_service.dart';
import 'package:bumble_clone/data/models/user_model.dart';

class IUserRepository {
  final UserService _service = UserService();

  Future<List<UserModel>?> call() async {
    return await _service.fetchUsers();
  }

  String getUserId() {
    return _service.getUserId();
  }

  Future<void> updateUser({
    required String userId,
    required String name,
    required DateTime birthDate,
    required String gender,
    required String preferredGender,
    required String profilePicture,
  }) async {
    await _service.updateAdditionalInfo(
      name: name,
      birthDate: birthDate,
      gender: gender,
      preferredGender: preferredGender,
      userId: userId,
      profilePicture: profilePicture,
    );
  }

  Future<Map<String, dynamic>> getAuthenticatedUser() async {
    return await _service.getAuthenticatedUser();
  }
}
