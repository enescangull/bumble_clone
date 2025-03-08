import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserEvent extends EditProfileEvent {}

class UpdateProfileEvent extends EditProfileEvent {
  final String? profilePicture;
  final String bio;

  const UpdateProfileEvent(this.profilePicture, this.bio);

  @override
  List<Object?> get props => [profilePicture, bio];
}
