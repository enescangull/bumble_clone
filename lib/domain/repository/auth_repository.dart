import 'package:bumble_clone/core/services/auth_service.dart';
import 'package:bumble_clone/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<void> login(String email, String password) async {
    await _authService.signIn(email, password);
  }

  Future<UserModel> register(String email, String password) async {
    return await _authService.signUp(email, password);
  }

  Future<void> logOut() async {
    await _authService.signOut();
  }

  String? getCurrentUserEmail() {
    return _authService.currentUser?.email;
  }
}
