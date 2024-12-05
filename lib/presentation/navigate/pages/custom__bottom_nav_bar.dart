import 'package:bumble_clone/common/app_colors.dart';
import 'package:bumble_clone/presentation/chat/pages/chat_screen.dart';
import 'package:bumble_clone/presentation/home/pages/swipe_screen.dart';
import 'package:bumble_clone/presentation/likedyou/pages/liked_you_screen.dart';
import 'package:bumble_clone/presentation/navigate/bloc/nav_bloc.dart';
import 'package:bumble_clone/presentation/navigate/bloc/nav_event.dart';
import 'package:bumble_clone/presentation/navigate/bloc/nav_state.dart';
import 'package:bumble_clone/presentation/profile/bloc/profile_bloc.dart';
import 'package:bumble_clone/presentation/profile/bloc/profile_event.dart';
import 'package:bumble_clone/presentation/profile/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int currentIndex = 1;
  final List<Widget> _pages = [
    const ProfileScreen(),
    const SwipeScreen(),
    const LikedYouScreen(),
    const ChatScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          if (state is BottomNavInitial) {
            return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                iconSize: 30,
                backgroundColor: AppColors.transparent,
                elevation: 0,
                fixedColor: AppColors.black,
                currentIndex: state.currentIndex,
                onTap: (index) {
                  context
                      .read<BottomNavBloc>()
                      .add(BottomNavItemSelected(index));
                  if (index == 2) {
                    BlocProvider.of<ProfileBloc>(context).add(LoadingProfile());
                  }
                },
                items: [
                  BottomNavigationBarItem(
                      icon: state.currentIndex == 0
                          ? const Icon(Icons.person)
                          : const Icon(Icons.person_outline_rounded),
                      label: "Profile"),
                  BottomNavigationBarItem(
                      icon: state.currentIndex == 1
                          ? const Icon(Icons.people_alt_rounded)
                          : const Icon(Icons.people_outline_rounded),
                      label: "People"),
                  BottomNavigationBarItem(
                      icon: state.currentIndex == 2
                          ? const Icon(Icons.favorite_rounded)
                          : const Icon(Icons.favorite_border_rounded),
                      label: "Liked You"),
                  BottomNavigationBarItem(
                      icon: state.currentIndex == 3
                          ? const Icon(Icons.chat_bubble)
                          : const Icon(Icons.chat_bubble_outline_rounded),
                      label: "Chat"),
                ]);
          }
          return const SizedBox.shrink();
        },
      ),
      body: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          if (state is BottomNavInitial) {
            return _pages[state.currentIndex];
          }
          return Container();
        },
      ),
    );
  }
}
