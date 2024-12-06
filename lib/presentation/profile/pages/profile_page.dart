import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/app_colors.dart';
import '../../../common/components/profile_components/premium_card/premium_card.dart';
import '../../../common/components/profile_components/special_interactions.dart';
import '../../../common/routes.dart';
import '../../../domain/repository/user_repository.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import 'settings_bottom_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final IUserRepository _userService = IUserRepository();
  String? name;
  String? profilePicture;
  String? bio;
  int? age;

  @override
  void initState() {
    super.initState();
    // context.read<ProfileBloc>().add(LoadingProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title:
            Text("Profile", style: Theme.of(context).textTheme.headlineLarge!),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const SettingsBottomSheet(),
                );
              },
              icon: const Icon(Icons.settings_outlined)),
        ],
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {
            showDialog(
              context: context,
              builder: (context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          } else if (state is ProfileLoaded) {
            setState(() {
              profilePicture = state.userModel.profilePicture ??
                  "https://picsum.photos/350/750";
              name = state.userModel.name ?? "Unknown User";
              age =
                  _userService.age(state.userModel.birthDate ?? DateTime.now());
              bio = state.userModel.bio ?? "";
            });
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18, top: 8),
                      child: Row(
                        children: [
                          //CircleAvatar Image
                          ClipRect(
                            clipBehavior: Clip.hardEdge,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    state.userModel.profilePicture!),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          // Name,and edit profile button
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.userModel.name!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              OutlinedButton(
                                  onPressed: () => Navigator.pushNamed(
                                      context, AppRoutes.home),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        size: 15,
                                        color: AppColors.grey,
                                      ),
                                      SizedBox(width: 5),
                                      Text("Edit Profile",
                                          style:
                                              TextStyle(color: AppColors.grey)),
                                    ],
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.lightGrey),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: SpecialInteractions(
                                  icon: Icons.light_mode,
                                  title: "Spotlight",
                                  subtitle: "Stand out",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.lightGrey),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: SpecialInteractions(
                                  icon: Icons.star_rounded,
                                  title: "SuperSwipe",
                                  subtitle: "Get noticed",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                      child: PremiumCard(),
                    ),
                  ],
                ),
              );
            }
            return const Scaffold();
          },
        ),
      ),
    );
  }
}
