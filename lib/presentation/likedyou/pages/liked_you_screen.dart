import 'package:bumble_clone/core/services/user_service.dart';
import 'package:bumble_clone/data/models/user_model.dart';
import 'package:bumble_clone/presentation/filter/pages/filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:bumble_clone/core/services/swipe_service.dart';
import 'package:bumble_clone/common/components/blurred_image.dart'; // Import BlurredImage widget

class LikedYouScreen extends StatefulWidget {
  const LikedYouScreen({super.key});

  @override
  State<LikedYouScreen> createState() => _LikedYouScreenState();
}

class _LikedYouScreenState extends State<LikedYouScreen> {
  final SwipeService _swipeService = SwipeService();
  final UserService _userService = UserService();
  List<UserModel>? likedUsers;

  @override
  void initState() {
    super.initState();
    _loadLikedUsers();
  }

  Future<void> _loadLikedUsers() async {
    final currentUser = await _userService.getAuthenticatedUser();
    if (currentUser != null) {
      final users = await _swipeService.getUsersWhoLikedYou(currentUser.id);
      if (mounted) {
        setState(() {
          likedUsers = users;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Liked You",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showBottomSheet(
                context: context,
                builder: (context) => const FilterSheet(),
              );
            },
            icon: const Icon(Icons.filter_list_rounded),
          )
        ],
      ),
      body: likedUsers == null
          ? const Center(child: CircularProgressIndicator())
          : likedUsers!.isEmpty
              ? const Center(
                  child: Text(
                      "When people are into you, they'll appear here. Enjoy."))
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: likedUsers!.length,
                  itemBuilder: (context, index) {
                    final user = likedUsers![index];
                    return BlurredImage(imageUrl: user.profilePicture);
                  },
                ),
    );
  }
}
