import 'dart:async';

import 'package:bumble_clone/data/models/match_model.dart';
import 'package:flutter/material.dart';

import '../../core/services/match_service.dart';
import '../../data/models/user_model.dart';
import '../../presentation/chat/pages/chat_with_match.dart';
import '../app_colors.dart';

class MatchCircleAvatar extends StatefulWidget {
  final MatchModel match;

  const MatchCircleAvatar({super.key, required this.match});

  @override
  State<MatchCircleAvatar> createState() => _MatchCircleAvatarState();
}

class _MatchCircleAvatarState extends State<MatchCircleAvatar> {
  UserModel? user;
  bool isLoading = true;
  late Timer _timer;
  double progress = 1.0;

  @override
  void initState() {
    super.initState();
    _loadMatchedUser();
    _startCountdown();
  }

  Future<void> _loadMatchedUser() async {
    try {
      final matchService = MatchService();
      final fetchedUser = await matchService.fetchMatchedUser(widget.match);
      if (mounted) {
        setState(() {
          user = fetchedUser;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading matched user: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _startCountdown() {
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (timer) {
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          widget.match.matchedAt.add(const Duration(hours: 24));
      final remainingTime = expiryTime.difference(now).inSeconds;

      if (remainingTime <= 0) {
        timer.cancel();
        setState(() {
          progress = 0;
        });
      } else {
        setState(() {
          progress = remainingTime /
              (24 * 60 * 60); // 24 saatlik sürecin yüzdesel hali
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatWithMatchScreen(
                matchedUser: user!,
                matchId: widget.match.id,
              ),
            ),
          ).then((_) {
            setState(() {});
          });
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 110,
            width: 110,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 4.0,
              backgroundColor: AppColors.grey,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primaryYellow),
            ),
          ),
          if (isLoading)
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.lightGrey,
              child: CircularProgressIndicator(),
            )
          else if (user != null)
            CircleAvatar(
              radius: 50,
              backgroundImage: user!.profilePicture != null &&
                      user!.profilePicture!.isNotEmpty
                  ? NetworkImage(user!.profilePicture!)
                  : const AssetImage("assets/images/default_pfp.png")
                      as ImageProvider,
              backgroundColor: AppColors.lightGrey,
              onBackgroundImageError: (exception, stackTrace) {
                print('Error loading match image: $exception');
              },
            )
          else
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.lightGrey,
              child: Icon(Icons.error_outline, color: AppColors.grey),
            ),
        ],
      ),
    );
  }
}
