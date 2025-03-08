import 'package:bumble_clone/core/di/service_locator.dart';
import 'package:bumble_clone/core/services/match_service.dart';
import 'package:bumble_clone/core/services/user_service.dart';
import 'package:bumble_clone/data/models/match_model.dart';
import 'package:bumble_clone/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:bumble_clone/common/app_colors.dart';
import 'package:bumble_clone/core/services/message_service.dart';
import 'package:bumble_clone/presentation/chat/pages/chat_with_match.dart';

class MatchedScreen extends StatefulWidget {
  final String userId;

  const MatchedScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<MatchedScreen> createState() => _MatchedScreenState();
}

class _MatchedScreenState extends State<MatchedScreen> {
  final UserService _userService = UserService();
  final MatchService _matchService = MatchService();
  final MessageService _messageService = MessageService();

  UserModel? currentUser;
  UserModel? matchedUser;
  String? matchId;
  bool isLoading = true;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Mevcut kullanıcıyı al
      currentUser = await _userService.getAuthenticatedUser();

      // Eşleşilen kullanıcıyı al
      final userResponse = await _userService.getUserById(widget.userId);
      matchedUser = userResponse;

      // Match ID'sini bul
      final matches = await _matchService.fetchMatches();
      if (matches != null) {
        for (var match in matches) {
          if ((match.user1Id == currentUser!.id &&
                  match.user2Id == widget.userId) ||
              (match.user2Id == currentUser!.id &&
                  match.user1Id == widget.userId)) {
            matchId = match.id;
            break;
          }
        }
      }
    } catch (e) {
      // Hata durumunda işlem yap
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty || matchId == null) return;

    try {
      await _messageService.sendMessage(
        matchId!,
        currentUser!.id,
        _messageController.text,
      );

      // Mesaj gönderildikten sonra chat ekranına git
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatWithMatchScreen(
              matchId: matchId!,
              matchedUser: matchedUser!,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mesaj gönderilirken hata oluştu: $e')),
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.darkYellow,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.black),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.darkYellow,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "It's a Match!",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Mevcut kullanıcının profil resmi
                      CircleAvatar(
                        radius: 70,
                        backgroundImage:
                            NetworkImage(currentUser!.profilePicture!),
                      ),
                      const SizedBox(width: 20),
                      // Eşleşilen kullanıcının profil resmi
                      CircleAvatar(
                        radius: 70,
                        backgroundImage:
                            NetworkImage(matchedUser!.profilePicture!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "You and ${matchedUser!.name} matched!",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Mesaj gönderme alanı
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        fillColor: AppColors.transparent,
                        hintText: "Send a message...",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Butonlar
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _sendMessage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryYellow,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Send Message",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Keep Swiping",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
