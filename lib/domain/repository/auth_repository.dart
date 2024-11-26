import 'package:bumble_clone/core/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<void> login(String email, String password) async {
    await _authService.signIn(email, password);
  }

  Future<void> register(String email, String password) async {
    await _authService.signUp(email, password);
  }

  Future<void> logOut() async {
    await _authService.signOut();
  }

  String? getCurrentUserEmail() {
    return _authService.currentUser?.email;
  }
}
