import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../../../common/app_colors.dart';
import '../../../common/components/swipe_card.dart';
import '../../../common/constants.dart';
import '../../filter/bloc/filter_bloc.dart';
import '../../filter/bloc/filter_event.dart';
import '../../filter/pages/filter_sheet.dart';

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
                  builder: (context) => const FilterSheet(),
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
