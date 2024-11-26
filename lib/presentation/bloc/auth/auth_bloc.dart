import 'package:bumble_clone/domain/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;

  RegisterEvent(
      {required this.email,
      required this.password,
      required this.confirmPassword});
}

class LogoutEvent extends AuthEvent {}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String email;

  Authenticated(this.email);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

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
        } catch (e) {
          emit(AuthError(e.toString()));
        }
      },
    );

    on<RegisterEvent>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          await _authRepository.register(event.email, event.password);
          final email = _authRepository.getCurrentUserEmail();
          emit(Authenticated(email!));
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
