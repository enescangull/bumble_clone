import 'package:bumble_clone/common/app_colors.dart';
import 'package:bumble_clone/core/services/user_service.dart';
import 'package:flutter/material.dart';

import '../../data/models/message_model.dart';

class ChatTile extends StatelessWidget {
  final MessageModel message;
  const ChatTile({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();
    final currentUserId = userService.getUserId();
    final bool isCurrentUser = message.senderId == currentUserId;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(
          left: isCurrentUser ? 50.0 : 12.0,
          right: isCurrentUser ? 12.0 : 50.0,
          bottom: 8.0,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser ? AppColors.darkYellow : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            message.content,
            style: TextStyle(
              color: isCurrentUser ? Colors.black : Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
