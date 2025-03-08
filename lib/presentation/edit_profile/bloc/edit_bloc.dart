import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bumble_clone/core/services/user_service.dart';

import 'edit_event.dart';
import 'edit_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UserService _userService;

  EditProfileBloc(this._userService) : super(EditProfileInitial()) {
    on<FetchUserEvent>(_onFetchUser);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onFetchUser(
      FetchUserEvent event, Emitter<EditProfileState> emit) async {
    try {
      emit(EditProfileLoading());
      final user = await _userService.getAuthenticatedUser();
      emit(EditProfileLoaded(user!));
    } catch (e) {
      emit(EditProfileError("Error fetching user data: $e"));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfileEvent event, Emitter<EditProfileState> emit) async {
    try {
      emit(EditProfileLoading());

      String? profilePictureUrl;

      if (event.profilePicture != null &&
          !event.profilePicture!.startsWith('http')) {
        profilePictureUrl =
            await _userService.uploadProfilePicture(event.profilePicture!);

        if (profilePictureUrl == null) {
          emit(const EditProfileError("Failed to upload profile picture"));
          return;
        }
      } else {
        profilePictureUrl = event.profilePicture;
      }

      await _userService.editProfile(profilePictureUrl, event.bio);

      final updatedUser = await _userService.getAuthenticatedUser();
      emit(EditProfileLoaded(updatedUser!, wasUpdated: true));
    } catch (e) {
      emit(EditProfileError("Error updating profile: $e"));
    }
  }
}
