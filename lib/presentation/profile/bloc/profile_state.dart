import 'package:bumble_clone/data/models/preferences_model.dart';

import '../../../data/models/user_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class LoadProfile extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel userModel;
  final PreferencesModel preferencesModel;

  ProfileLoaded({required this.userModel, required this.preferencesModel});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
