import 'package:equatable/equatable.dart';

import '../../../data/models/user_model.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object?> get props => [];
}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileLoaded extends EditProfileState {
  final UserModel user;
  final bool wasUpdated;

  const EditProfileLoaded(this.user, {this.wasUpdated = false});

  @override
  List<Object?> get props => [user, wasUpdated];
}

class EditProfileUpdated extends EditProfileState {}

class EditProfileError extends EditProfileState {
  final String message;

  const EditProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
