import 'package:flutter/material.dart';

import '../presentation/auth/pages/login_page.dart';
import '../presentation/auth/pages/register_page.dart';
import '../presentation/chat/pages/chat_screen.dart';
import '../presentation/home/pages/swipe_screen.dart';
import '../presentation/likedyou/pages/liked_you_screen.dart';
import '../presentation/navigate/pages/custom__bottom_nav_bar.dart';
import '../presentation/onboard/pages/onboarding_screen.dart';
import '../presentation/profile/pages/profile_page.dart';

class AppRoutes {
  static const String nav = '/nav';
  static const String home = '/home';
  static const String onboarding = '/onboarding';
  static const String register = '/register';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String chat = '/chat';
  static const String likedYou = '/likedyou';

  static Map<String, Widget Function(BuildContext)> get routes => {
        nav: (context) => const CustomBottomNavBar(),
        home: (context) => const SwipeScreen(),
        onboarding: (context) => const OnboardingScreen(),
        register: (context) => const RegisterScreen(),
        login: (context) => const LoginPage(),
        profile: (context) => const ProfileScreen(),
        chat: (context) => const ChatScreen(),
        likedYou: (context) => const LikedYouScreen(),
      };
}
