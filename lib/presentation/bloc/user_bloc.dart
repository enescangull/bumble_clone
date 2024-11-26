import 'package:bumble_clone/domain/data/user_entity.dart';
import 'package:bumble_clone/domain/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UserEvent {}

class FetchUsers extends UserEvent {}

abstract class UserState {}

class UsersLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<UserEntity> users;

  UsersLoaded(this.users);
}

class UserBloc extends Bloc<UserEvent, UserState> {
  final IUserRepository _userRepository;

  UserBloc(this._userRepository) : super(UsersLoading()) {
    on<FetchUsers>((event, emit) async {
      emit(UsersLoading());
      try {
        final users = await _userRepository();
        emit(UsersLoaded(users));
      } catch (_) {
        emit(UsersLoading());
      }
    });
  }
}
