import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../../../common/app_colors.dart';
import '../../../common/components/nobody_field.dart';
import '../../../common/components/swipe_card.dart';
import '../../../common/constants.dart';
import '../../../common/ui_constants.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/services/preferences_service.dart';
import '../../../core/services/swipe_service.dart';
import '../../../core/services/user_service.dart';
import '../../../data/models/preferences_model.dart';
import '../../../data/models/user_model.dart';
import '../../filter/bloc/filter_bloc.dart';
import '../../filter/bloc/filter_event.dart';
import '../../filter/bloc/filter_state.dart';
import '../../filter/pages/filter_sheet.dart';
import 'matched_screen.dart';

/// Kullanıcı kartlarını kaydırma ekranı.
///
/// Bu ekran, kullanıcıların diğer kullanıcıları sağa veya sola kaydırarak
/// beğenme veya beğenmeme işlemlerini gerçekleştirmelerini sağlar.
class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  final UserService _userService = getIt<UserService>();
  final PreferencesService _preferenceService = getIt<PreferencesService>();
  final SwipeService _swipeService = getIt<SwipeService>();
  int? maxDistance;
  List<UserModel>? users;
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  /// Başlangıç verilerini yükler.
  ///
  /// Kullanıcı bilgilerini, tercihlerini ve filtrelenmiş kullanıcı listesini getirir.
  /// Kullanıcı oturum açmamışsa, giriş ekranına yönlendirir.
  Future<void> _loadInitialData() async {
    currentUser = await _userService.getAuthenticatedUser();
    if (currentUser == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
      return;
    }
    final PreferencesModel preferences =
        await _preferenceService.fetchUserPreferences();
    final List<UserModel> fetchedUsers =
        await _preferenceService.fetchFilteredUsers(currentUser!.id);
    if (mounted) {
      setState(() {
        users = fetchedUsers;
        maxDistance = preferences.distance;
      });
    }
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
          height: UIConstants.appBarHeight,
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
              icon: const Icon(Icons.filter_list, size: UIConstants.iconSize)),
        ],
      ),
      body: BlocListener<FilterBloc, FilterState>(
          listener: (context, state) {
            if (state is PreferencesUpdated) {
              _loadInitialData();
            }
          },
          child: users == null || users!.isEmpty
              ? const NobodyField()
              : CardSwiper(
                  allowedSwipeDirection: const AllowedSwipeDirection.only(
                      right: true, left: true, up: false, down: false),
                  onSwipe: (previousIndex, currentIndex, direction) async {
                    if (currentIndex! <= users!.length - 1) {
                      if (direction == CardSwiperDirection.right) {
                        final userId = users![previousIndex].id;
                        bool isMatched = await _swipeService.likeUser(userId);

                        if (isMatched) {
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MatchedScreen(
                                  userId: userId,
                                ),
                              ),
                            );
                          }
                        }
                      } else if (direction == CardSwiperDirection.left) {
                        final userId = users![previousIndex].id;
                        _swipeService.dislikeUser(userId);
                      }

                      if (previousIndex == users!.length - 1) {
                        users!.clear();
                      }
                    }

                    return true;
                  },
                  numberOfCardsDisplayed: users!.isNotEmpty ? 1 : 0,
                  cardBuilder: (context, index, horizontalOffsetPercentage,
                      verticalOffsetPercentage) {
                    if (index >= users!.length) {
                      return const NobodyField();
                    }
                    final user = users![index];
                    return SwipeCard(user: user);
                  },
                  cardsCount: users!.length,
                )),
    );
  }
}
