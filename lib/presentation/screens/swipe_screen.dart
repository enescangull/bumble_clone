import 'package:bumble_clone/common/app_colors.dart';
import 'package:bumble_clone/common/components/swipe_card.dart';
import 'package:bumble_clone/common/constants.dart';
import 'package:bumble_clone/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class SwipeScreen extends StatelessWidget {
  const SwipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService _service = AuthService();
    const String image = "https://picsum.photos/350/750";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        title: Image.asset(
          Constants.bumbleLogo,
          fit: BoxFit.cover,
          height: 64,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out successfuully')));
                _service.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: Center(
          child: CardSwiper(
        maxAngle: 180,
        cardBuilder: (context, index, horizontalOffsetPercentage,
                verticalOffsetPercentage) =>
            const SwipeCard(image: image),
        cardsCount: 3,
      )),
    );
  }
}
