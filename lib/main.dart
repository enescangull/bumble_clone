import 'package:bumble_clone/presentation/bloc/auth/auth_bloc.dart';
import 'package:bumble_clone/presentation/bloc/onboarding/onboarding_bloc.dart';
import 'package:bumble_clone/presentation/screens/onboarding_screen.dart';
import 'package:bumble_clone/presentation/screens/register_page.dart';
import 'package:bumble_clone/presentation/screens/swipe_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.instance.initialize();
  runApp(BlocProvider<AuthBloc>(
    create: (context) => AuthBloc(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => const SwipeScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Bumble Clone',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const LoginPage(),
    );
  }
}
