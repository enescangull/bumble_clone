import '../../../data/models/user_model.dart';

abstract class UserState {}

class UsersLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<UserModel>? users;

  UsersLoaded(this.users);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}
