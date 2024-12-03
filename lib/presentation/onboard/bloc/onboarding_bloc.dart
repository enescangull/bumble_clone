import 'package:bumble_clone/domain/repository/preference_repository.dart';
import 'package:bumble_clone/domain/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final IUserRepository _repository = IUserRepository();
  final PreferenceRepository _preferenceRepository = PreferenceRepository();

  OnboardingBloc() : super(OnboardingInitial()) {
    on<LoadInitialData>((event, emit) async {
      emit(OnboardingLoading());
      try {
        await _repository.getAuthenticatedUser();
        emit(OnboardingSuccess());
      } catch (e) {
        emit(OnboardingFailure(e.toString()));
      }
    });

    on<SubmitOnboardingData>((event, emit) async {
      emit(OnboardingLoading());

      try {
        await _repository.updateUser(
          name: event.name,
          birthDate: event.birthDate,
          gender: event.gender,
          profilePicture: event.profilePicture,
        );
        await _preferenceRepository.onboardPreferences(
            preferredGender: event.preferredGender);

        emit(OnboardingSuccess());
      } catch (error) {
        emit(OnboardingFailure("Hata burda ${error.toString()}"));
        print(error.toString());
      }
    });
  }
}
