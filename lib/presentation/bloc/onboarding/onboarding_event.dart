abstract class OnboardingEvent {}

class LoadInitialData extends OnboardingEvent {}

class SubmitOnboardingData extends OnboardingEvent {
  final Map<String, dynamic> userData;

  SubmitOnboardingData({required this.userData});
}
