import 'package:bumble_clone/data/repositories/user_repository.dart';
import 'package:bumble_clone/domain/data/user_entity.dart';

class IUserRepository {
  final UserRepository repository;

  IUserRepository(this.repository);
  Future<List<UserEntity>> call() async {
    return await repository.fetchUsers();
  }
}
