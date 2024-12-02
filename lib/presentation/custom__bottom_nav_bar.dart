import 'package:bumble_clone/common/app_colors.dart';
import 'package:bumble_clone/presentation/chat/pages/chat_screen.dart';
import 'package:bumble_clone/presentation/home/pages/swipe_screen.dart';
import 'package:bumble_clone/presentation/likedyou/pages/liked_you_screen.dart';
import 'package:bumble_clone/presentation/profile/pages/profile_page.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _currentIndex = 1;
  final List<Widget> _pages = [
    const ProfileScreen(),
    const SwipeScreen(),
    const LikedYouScreen(),
    const ChatScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
          backgroundColor: AppColors.transparent,
          elevation: 0,
          fixedColor: AppColors.black,
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
                icon: _currentIndex == 0
                    ? const Icon(Icons.person)
                    : const Icon(Icons.person_outline_rounded),
                label: "Profile"),
            BottomNavigationBarItem(
                icon: _currentIndex == 1
                    ? const Icon(Icons.people_alt_rounded)
                    : const Icon(Icons.people_outline_rounded),
                label: "People"),
            BottomNavigationBarItem(
                icon: _currentIndex == 2
                    ? const Icon(Icons.favorite_rounded)
                    : const Icon(Icons.favorite_border_rounded),
                label: "Liked You"),
            BottomNavigationBarItem(
                icon: _currentIndex == 3
                    ? const Icon(Icons.chat_bubble)
                    : const Icon(Icons.chat_bubble_outline_rounded),
                label: "Chat"),
          ]),
      body: _pages[_currentIndex],
    );
  }
}
