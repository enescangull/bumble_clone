import 'package:bumble_clone/data/models/user_model.dart';
import 'package:bumble_clone/presentation/filter/pages/filter_sheet.dart';
import 'package:bumble_clone/presentation/navigate/bloc/nav_bloc.dart';
import 'package:bumble_clone/presentation/navigate/bloc/nav_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikedYouScreen extends StatelessWidget {
  const LikedYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<UserModel>? users;
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "When people are into you, the'll appear here. Enjoy.",
              style:
                  Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 22),
            ),
            const Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Visibility(
                    visible: true,
                    child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<BottomNavBloc>()
                              .add(BottomNavItemSelected(1));
                        },
                        child: const Text("See more people"))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
