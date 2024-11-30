import 'package:bumble_clone/domain/repository/auth_repository.dart';

import 'package:bumble_clone/presentation/auth/bloc/auth_event.dart';
import 'package:bumble_clone/presentation/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          await _authRepository.login(event.email, event.password);
          final email = _authRepository.getCurrentUserEmail();
          emit(Authenticated(email!));
          // emit(AuthOnboardingRequired());
        } catch (e) {
          emit(AuthError(e.toString()));
        }
      },
    );

    on<RegisterEvent>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          if (event.password != event.confirmPassword) {
            throw Exception("Passwords do not match!");
          }

          await _authRepository.register(event.email, event.password);

          emit(AuthOnboardingRequired());
        } catch (e) {
          emit(AuthError(e.toString()));
        }
      },
    );

    on<LogoutEvent>(
      (event, emit) async {
        await _authRepository.logOut();
        emit(AuthInitial());
      },
    );
  }
}
