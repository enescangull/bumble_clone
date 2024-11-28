import 'package:bumble_clone/core/services/user_service.dart';
import 'package:bumble_clone/data/models/user_model.dart';

class IUserRepository {
  final UserService _service = UserService();

  Future<List<UserModel>?> call() async {
    return await _service.fetchUsers();
  }

  Future<void> updateUser(Map<String, dynamic> profileData) async {
    await _service.updateUser(profileData);
  }

  Future<Map<String, dynamic>> getAuthenticatedUser() async {
    return await _service.getAuthenticatedUser();
  }
}
