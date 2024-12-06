import '../../../data/models/user_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class LoadProfile extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel userModel;

  ProfileLoaded({required this.userModel});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
