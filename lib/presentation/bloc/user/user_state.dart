import 'package:bumble_clone/domain/data/user_entity.dart';

abstract class UserState {}

class UsersLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<UserEntity> users;

  UsersLoaded(this.users);
}
