import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/preferences_model.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/repository/preference_repository.dart';
import '../../../domain/repository/user_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IUserRepository _userRepository = IUserRepository();
  final PreferenceRepository _preferenceRepository = PreferenceRepository();
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadingProfile>(
      (event, emit) async {
        emit(ProfileLoading());
        try {
          final UserModel user = await _userRepository.getAuthenticatedUser();
          final PreferencesModel preferences =
              await _preferenceRepository.fetchPreferences();
          emit(ProfileLoaded(userModel: user, preferencesModel: preferences));
        } catch (e) {
          emit(ProfileError(e.toString()));
        }
      },
    );
  }
}
