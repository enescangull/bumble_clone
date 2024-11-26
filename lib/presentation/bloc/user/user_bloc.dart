import 'package:bumble_clone/domain/repository/user_repository.dart';
import 'package:bumble_clone/presentation/bloc/user/user_event.dart';
import 'package:bumble_clone/presentation/bloc/user/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
