import 'package:bumble_clone/presentation/chat/pages/chat_with_match.dart';
import 'package:flutter/material.dart';

import '../../core/services/match_service.dart';
import '../../core/services/message_service.dart';
import '../../data/models/match_model.dart';
import '../../data/models/message_model.dart';
import '../../data/models/user_model.dart';
import '../constants.dart';
import 'chat_actions_bottom_sheet.dart';

class ChatListTile extends StatefulWidget {
  final MatchModel match;
  const ChatListTile({super.key, required this.match});

  @override
  State<ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile> {
  final MatchService _matchService = MatchService();
  final MessageService messageService = MessageService();
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _loadMatchedUser();
  }

  Future<void> _loadMatchedUser() async {
    final fetchedUser = await _matchService.fetchMatchedUser(widget.match);
    if (mounted) {
      setState(() {
        user = fetchedUser;
      });
    }
  }

  void _showActionsBottomSheet() {
    ChatActionsBottomSheet.show(
      context: context,
      matchedUser: user!,
      matchId: widget.match.id,
      onUnmatch: () {
        // Custom unmatch islemi
        Navigator.pop(context); // Bottom sheet'i kapat
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Eslesmeyi Sonlandir'),
            content: const Text(
                'Bu eslesmeyi sonlandirmak istediginizden emin misiniz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Iptal'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    // Eslesmeyi sil
                    final success =
                        await _matchService.deleteMatch(widget.match.id);

                    // Dialog ve chat ekranini kapat
                    Navigator.pop(context); // Dialog'u kapat
                    Navigator.pop(context); // Sohbet ekranini kapat

                    // Sonucu bildir
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Eslesme basariyla sonlandirildi')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Eslesme sonlandirilirken bir hata olustu')),
                      );
                    }
                  } catch (e) {
                    Navigator.pop(context); // Dialog'u kapat
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Hata: $e')),
                    );
                  }
                },
                child: const Text('Sonlandir',
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: user?.profilePicture != null
                  ? NetworkImage(user!.profilePicture!)
                  : const AssetImage(Constants.defaultPfp) as ImageProvider,
              radius: 40,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? "Unknown user",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  StreamBuilder<MessageModel?>(
                      stream:
                          messageService.getLastMessageStream(widget.match.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("");
                        } else if (snapshot.hasError) {
                          return const Text("Something went wrong.");
                        } else if (snapshot.hasData && snapshot.data != null) {
                          return Text(
                            snapshot.data!.content,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.grey[600],
                                ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          );
                        } else {
                          return const Text("No messages yet.");
                        }
                      })
                ],
              ),
            ),
            const Spacer(),
            IconButton(
                onPressed: _showActionsBottomSheet,
                icon: const Icon(Icons.more_vert))
          ],
        ),
      ),
    );
  }
}
