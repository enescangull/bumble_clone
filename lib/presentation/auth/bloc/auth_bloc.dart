import 'package:bumble_clone/core/exceptions/app_exceptions.dart';
import 'package:bumble_clone/domain/repository/auth_repository.dart';
import 'package:bumble_clone/domain/repository/user_repository.dart';

import 'package:bumble_clone/presentation/auth/bloc/auth_event.dart';
import 'package:bumble_clone/presentation/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final IUserRepository _userRepository;

  AuthBloc(this._authRepository, this._userRepository) : super(AuthInitial()) {
    on<LoginEvent>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          await _authRepository.login(event.email, event.password);
          final email = _authRepository.getCurrentUserEmail();
          _userRepository.updateLocation();
          emit(Authenticated(email!));
          // emit(AuthOnboardingRequired());
        } catch (e) {
          if (e is AuthException) {
            emit(AuthError(e.message));
          } else {
            emit(AuthError(e.toString()));
          }
        }
      },
    );

    on<RegisterEvent>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          if (event.password != event.confirmPassword) {
            throw AuthException.passwordMismatch();
          }

          await _authRepository.register(event.email, event.password);
          _userRepository.updateLocation();

          emit(AuthOnboardingRequired());
        } catch (e) {
          if (e is AuthException) {
            emit(AuthError(e.message));
          } else {
            emit(AuthError(e.toString()));
          }
        }
      },
    );

    on<LogoutEvent>(
      (event, emit) async {
        try {
          await _authRepository.logOut();
          emit(AuthInitial());
        } catch (e) {
          if (e is AuthException) {
            emit(AuthError(e.message));
          } else {
            emit(AuthError(e.toString()));
          }
        }
      },
    );
  }
}
