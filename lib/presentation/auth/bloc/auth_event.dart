import 'package:flutter/material.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class ToOnboarding extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;

  ToOnboarding(
      {required this.email,
      required this.password,
      required this.confirmPassword});
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

class LogoutEvent extends AuthEvent {
  final BuildContext context;

  LogoutEvent(this.context);
}
