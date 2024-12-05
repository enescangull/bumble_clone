import 'package:bumble_clone/common/app_colors.dart';
import 'package:bumble_clone/common/components/profile_components/premium_card/premium_features.dart';
import 'package:bumble_clone/common/components/profile_components/special_interactions.dart';
import 'package:bumble_clone/common/routes.dart';
import 'package:bumble_clone/presentation/profile/bloc/profile_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/components/profile_components/premium_card/premium_card.dart';
import '../../../core/services/auth_service.dart';
import '../../../domain/repository/user_repository.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_state.dart';

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
    context.read<ProfileBloc>().add(LoadingProfile());
  }

  @override
  Widget build(BuildContext context) {
    final AuthService service = AuthService();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Profile",
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontSize: 25, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
              onPressed: () {
                service.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(Icons.logout_outlined)),
        ],
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            setState(() {
              profilePicture = state.userModel.profilePicture ??
                  "https://picsum.photos/350/750";
              name = state.userModel.name ?? "Unknown User";
              age =
                  _userService.age(state.userModel.birthDate ?? DateTime.now());
              bio = state.userModel.bio ?? "";
            });
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
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
                                backgroundImage: NetworkImage(profilePicture!),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          // Name,age and edit profile button
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name!,
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
            return const Text("Oops... somethings gone wrong!");
          },
        ),
      ),
    );
  }
}
