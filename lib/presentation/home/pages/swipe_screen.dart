import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/preferences_service.dart';
import '../../../core/services/user_service.dart';
import '../../../data/models/user_model.dart';
// / import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../../../common/app_colors.dart';
// import '../../../common/components/swipe_card.dart';
import '../../../common/constants.dart';
import '../../filter/bloc/filter_bloc.dart';
import '../../filter/bloc/filter_event.dart';
import '../../filter/bloc/filter_state.dart';
import '../../filter/pages/filter_sheet.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  final UserService _userService = UserService();
  final PreferencesService _preferenceService = PreferencesService();
  List<UserModel>? users;
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    currentUser = await _userService.getAuthenticatedUser();
    final List<UserModel> fetchedUsers =
        await _preferenceService.fetchFilteredUsers(currentUser!.id);
    setState(() {
      users = fetchedUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () async {
                BlocProvider.of<FilterBloc>(context).add(GetFilterParameters());

                final controller = Scaffold.of(context).showBottomSheet(
                  (context) => const FilterSheet(),
                );
                controller.closed.then((_) {
                  _loadInitialData();
                });
              },
              icon: const Icon(Icons.filter_list)),
        ],
      ),
      body: BlocListener<FilterBloc, FilterState>(
        listener: (context, state) {
          if (state is PreferencesUpdated) {
            _loadInitialData;
          }
        },
        child: users == null
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: users!.length,
                itemBuilder: (BuildContext context, int index) {
                  final user = users![index];
                  final userAge = _userService.calculateAge(user.birthDate!);
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePicture!)),
                      title: Text(user.name ?? 'Unknown user'),
                      subtitle: Text(userAge.toString()),
                    ),
                  );
                },
              ),
      ),
      // Center(
      //     child: CardSwiper(
      //   maxAngle: 180,
      //   cardBuilder: (context, index, horizontalOffsetPercentage,
      //           verticalOffsetPercentage) =>
      //       const SwipeCard(image: "https://picsum.photos/200/300"),
      //   cardsCount: 3,
      // )),
    );
  }
}
