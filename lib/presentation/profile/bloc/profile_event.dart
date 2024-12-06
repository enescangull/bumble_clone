import 'package:bumble_clone/data/models/user_model.dart';

abstract class ProfileEvent {}

class LoadingProfile extends ProfileEvent {}

class LoadedProfile extends ProfileEvent {
  final UserModel userModel;

  LoadedProfile({required this.userModel});
}

class ResetProfile extends ProfileEvent {}
