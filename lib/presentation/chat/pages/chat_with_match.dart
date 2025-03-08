import 'package:bumble_clone/common/components/swipe_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/app_colors.dart';
import '../../../common/components/chat_actions_bottom_sheet.dart';
import '../../../common/components/chat_tile.dart';
import '../../../core/services/match_service.dart';
import '../../../core/services/message_service.dart';
import '../../../core/services/user_service.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/user_model.dart';

class ChatWithMatchScreen extends StatefulWidget {
  final String matchId;
  final UserModel matchedUser;

  const ChatWithMatchScreen(
      {super.key, required this.matchId, required this.matchedUser});

  @override
  State<ChatWithMatchScreen> createState() => _ChatWithMatchScreenState();
}

class _ChatWithMatchScreenState extends State<ChatWithMatchScreen> {
  final TextEditingController _messageController = TextEditingController();
  final MessageService _messageService = MessageService();
  final UserService _userService = UserService();
  final MatchService _matchService = MatchService();
  final ScrollController _scrollController = ScrollController();
  late String currentUserId;
  bool isTextEmpty = true;

  @override
  void initState() {
    super.initState();
    currentUserId = _userService.getUserId();
    _messageController.addListener(_checkTextEmpty);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _checkTextEmpty() {
    setState(() {
      isTextEmpty = _messageController.text.isEmpty;
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _messageService.sendMessage(
          widget.matchId, currentUserId, _messageController.text);
      _messageController.clear();
      setState(() {});
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now().toLocal();
    final differance = now.difference(date).inDays;

    if (differance == 0) {
      return "Today";
    } else if (differance == 1) {
      return "Yesterday";
    } else {
      return DateFormat("dd MMMM yyyy").format(date);
    }
  }

  void _showActionsBottomSheet() {
    ChatActionsBottomSheet.show(
      context: context,
      matchedUser: widget.matchedUser,
      matchId: widget.matchId,
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
                        await _matchService.deleteMatch(widget.matchId);

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
    _messageController.removeListener(_checkTextEmpty);
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: SwipeCard(user: widget.matchedUser),
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundImage:
                    NetworkImage(widget.matchedUser.profilePicture!),
                backgroundColor: AppColors.grey,
              ),
            ),
            const SizedBox(width: 8),
            Text(widget.matchedUser.name!),
          ],
        ),
        actions: [
          IconButton(
              onPressed: _showActionsBottomSheet,
              icon: const Icon(Icons.more_vert))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<List<MessageModel>>(
                  stream: _messageService.getMessages(widget.matchId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text("Something went wrong."));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No messages yet."));
                    } else {
                      final messages = snapshot.data!;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });
                      Map<String, List<MessageModel>> groupedMessages = {};
                      for (var message in messages) {
                        final dateKey = _formatDate(message.createdAt);
                        if (!groupedMessages.containsKey(dateKey)) {
                          groupedMessages[dateKey] = [];
                        }
                        groupedMessages[dateKey]!.add(message);
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: groupedMessages.keys.length,
                        itemBuilder: (context, dateIndex) {
                          final dateKey =
                              groupedMessages.keys.elementAt(dateIndex);
                          final messagesForDate = groupedMessages[dateKey]!;

                          return Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 12, bottom: 4),
                                  child: Text(
                                    dateKey,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            color: AppColors.grey,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              ...messagesForDate.map((message) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: ChatTile(message: message),
                                );
                              }),
                            ],
                          );
                        },
                      );
                    }
                  })),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: AppColors.grey),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        filled: false,
                        hintStyle: TextStyle(color: AppColors.grey),
                        hintText: 'Aa',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isTextEmpty
                          ? AppColors.lightGrey
                          : AppColors.primaryYellow,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                        onPressed: isTextEmpty ? null : _sendMessage,
                        icon: Icon(Icons.send,
                            color: isTextEmpty
                                ? AppColors.grey
                                : AppColors.black)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
