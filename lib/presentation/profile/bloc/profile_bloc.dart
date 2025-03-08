import 'package:bumble_clone/core/exceptions/app_exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_model.dart';
import '../../../domain/repository/user_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// Profil işlemlerini yöneten BLoC sınıfı.
///
/// Bu sınıf, kullanıcı profilinin yüklenmesi ve sıfırlanması gibi
/// profil işlemlerini yönetir.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IUserRepository _userRepository;

  /// ProfileBloc sınıfının constructor'ı.
  ///
  /// [_userRepository] parametresi, kullanıcı işlemlerini gerçekleştiren repository'yi alır.
  ProfileBloc(this._userRepository) : super(ProfileInitial()) {
    on<LoadingProfile>(
      (event, emit) async {
        emit(ProfileLoading());
        try {
          final UserModel user = await _userRepository.getAuthenticatedUser();

          emit(ProfileLoaded(userModel: user));
        } catch (e) {
          if (e is UserException) {
            emit(ProfileError(e.message));
          } else {
            emit(ProfileError(e.toString()));
          }
        }
      },
    );
    on<ResetProfile>((event, emit) {
      emit(ProfileInitial());
    });
  }
}
