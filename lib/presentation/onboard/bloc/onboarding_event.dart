abstract class OnboardingEvent {}

class LoadInitialData extends OnboardingEvent {
  void add() {}
}

class SubmitOnboardingData extends OnboardingEvent {
  final String name;
  final String gender;
  final String preferredGender;
  final DateTime birthDate;
  final String profilePicture;

  SubmitOnboardingData({
    required this.name,
    required this.gender,
    required this.preferredGender,
    required this.birthDate,
    required this.profilePicture,
  });
}
