import 'package:bumble_clone/core/services/supabase_service.dart';
import 'package:bumble_clone/domain/data/user_entity.dart';

class UserRepository {
  final SupabaseService _supabase = SupabaseService.instance;

  Future<List<UserEntity>> fetchUsers() async {
    final response = await _supabase.client.from('users').select();
    return (response as List).map((user) => UserEntity.fromMap(user)).toList();
  }
}
