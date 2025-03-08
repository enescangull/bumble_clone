import 'package:bumble_clone/core/exceptions/app_exceptions.dart';
import 'package:bumble_clone/domain/repository/preference_repository.dart';
import 'package:bumble_clone/domain/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

/// Kullanıcı onboarding işlemlerini yöneten BLoC sınıfı.
///
/// Bu sınıf, kullanıcının ilk kayıt sonrası profil bilgilerini doldurması ve
/// tercihlerini belirlemesi gibi onboarding işlemlerini yönetir.
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final IUserRepository _repository;
  final PreferenceRepository _preferenceRepository;

  /// OnboardingBloc sınıfının constructor'ı.
  ///
  /// [_repository] parametresi, kullanıcı işlemlerini gerçekleştiren repository'yi alır.
  /// [_preferenceRepository] parametresi, tercih işlemlerini gerçekleştiren repository'yi alır.
  OnboardingBloc(this._repository, this._preferenceRepository)
      : super(OnboardingInitial()) {
    /// Başlangıç verilerini yükler.
    ///
    /// Kullanıcının kimlik doğrulamasını kontrol eder.
    /// Başarılı olursa [OnboardingSuccess] durumuna geçer.
    /// Başarısız olursa [OnboardingFailure] durumuna geçer.
    on<LoadInitialData>((event, emit) async {
      emit(OnboardingLoading());
      try {
        await _repository.getAuthenticatedUser();
        emit(OnboardingSuccess());
      } catch (e) {
        if (e is UserException) {
          emit(OnboardingFailure(e.message));
        } else {
          emit(OnboardingFailure(e.toString()));
        }
      }
    });

    /// Onboarding verilerini gönderir.
    ///
    /// [event] parametresi, kullanıcının girdiği onboarding verilerini içerir.
    /// Başarılı olursa [OnboardingSuccess] durumuna geçer.
    /// Başarısız olursa [OnboardingFailure] durumuna geçer.
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
        if (error is UserException) {
          emit(OnboardingFailure(error.message));
        } else {
          emit(OnboardingFailure(
              "Onboarding işlemi sırasında bir hata oluştu: ${error.toString()}"));
        }
      }
    });
  }
}
