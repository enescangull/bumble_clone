import 'package:bumble_clone/common/app_colors.dart';

import 'package:bumble_clone/common/components/swipe_card.dart';
import 'package:bumble_clone/common/constants.dart';
import 'package:bumble_clone/core/services/auth_service.dart';
import 'package:bumble_clone/presentation/filter/bloc/filter_bloc.dart';
import 'package:bumble_clone/presentation/filter/bloc/filter_event.dart';
import 'package:bumble_clone/presentation/filter/pages/filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class SwipeScreen extends StatelessWidget {
  const SwipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          IconButton(
              onPressed: () {
                BlocProvider.of<FilterBloc>(context).add(GetFilterParameters());

                showBottomSheet(
                  context: context,
                  builder: (context) => FilterSheet(),
                );
              },
              icon: const Icon(Icons.filter_list)),
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
