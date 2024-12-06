import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_model.dart';
import '../../../domain/repository/user_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IUserRepository _userRepository = IUserRepository();
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadingProfile>(
      (event, emit) async {
        emit(ProfileLoading());
        try {
          final UserModel user = await _userRepository.getAuthenticatedUser();

          emit(ProfileLoaded(userModel: user));
        } catch (e) {
          emit(ProfileError(e.toString()));
        }
      },
    );
    on<ResetProfile>((event, emit) {
      emit(ProfileInitial());
    });
  }
}
