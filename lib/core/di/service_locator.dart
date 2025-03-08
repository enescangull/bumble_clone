import 'package:get_it/get_it.dart';

import '../../domain/repository/auth_repository.dart';
import '../../domain/repository/preference_repository.dart';
import '../../domain/repository/user_repository.dart';
import '../services/auth_service.dart';
import '../services/preferences_service.dart';
import '../services/swipe_service.dart';
import '../services/user_service.dart';
import '../../presentation/auth/bloc/auth_bloc.dart';
import '../../presentation/filter/bloc/filter_bloc.dart';
import '../../presentation/navigate/bloc/nav_bloc.dart';
import '../../presentation/onboard/bloc/onboarding_bloc.dart';
import '../../presentation/profile/bloc/profile_bloc.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Services
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<UserService>(() => UserService());
  getIt.registerLazySingleton<PreferencesService>(() => PreferencesService());
  getIt.registerLazySingleton<SwipeService>(() => SwipeService());

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepository(getIt<AuthService>()));
  getIt.registerLazySingleton<IUserRepository>(
      () => IUserRepository(getIt<UserService>()));
  getIt.registerLazySingleton<PreferenceRepository>(
      () => PreferenceRepository(getIt<PreferencesService>()));

  // BLoCs
  getIt.registerFactory<AuthBloc>(
      () => AuthBloc(getIt<AuthRepository>(), getIt<IUserRepository>()));
  getIt.registerFactory<FilterBloc>(
      () => FilterBloc(getIt<PreferenceRepository>()));
  getIt.registerFactory<ProfileBloc>(
      () => ProfileBloc(getIt<IUserRepository>()));
  getIt.registerFactory<OnboardingBloc>(() =>
      OnboardingBloc(getIt<IUserRepository>(), getIt<PreferenceRepository>()));
  getIt.registerFactory<BottomNavBloc>(() => BottomNavBloc());
}
