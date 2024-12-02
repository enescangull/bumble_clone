import 'package:bumble_clone/presentation/filter/bloc/filter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'presentation/auth/bloc/auth_bloc.dart';
import 'presentation/auth/pages/login_page.dart';
import 'presentation/auth/pages/register_page.dart';
import 'presentation/chat/pages/chat_screen.dart';
import 'presentation/custom__bottom_nav_bar.dart';
import 'presentation/home/pages/swipe_screen.dart';
import 'presentation/likedyou/pages/liked_you_screen.dart';
import 'presentation/onboard/pages/onboarding_screen.dart';
import 'presentation/profile/pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.instance.initialize();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => FilterBloc()),
      BlocProvider(create: (context) => AuthBloc())
    ],
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
        '/nav': (context) => const CustomBottomNavBar(),
        '/home': (context) => const SwipeScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginPage(),
        '/profile': (context) => const ProfileScreen(),
        '/chat': (context) => const ChatScreen(),
        '/likedyou': (context) => const LikedYouScreen(),
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
