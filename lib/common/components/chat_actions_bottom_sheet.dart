import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../ui_constants.dart';
import '../../data/models/user_model.dart';
import '../../core/services/match_service.dart';

/// Chat ekraninda aksiyonlar icin kullanilan bottom sheet.
///
/// Bu bilesen kullaniciya eslesmeyi sonlandirma, kullaniciyi sikayet etme ve
/// kullaniciyi engelleme gibi eylemler sunar.
class ChatActionsBottomSheet extends StatelessWidget {
  final UserModel matchedUser;
  final String matchId;
  final VoidCallback? onUnmatch;
  final VoidCallback? onReport;
  final VoidCallback? onBlock;

  const ChatActionsBottomSheet({
    Key? key,
    required this.matchedUser,
    required this.matchId,
    this.onUnmatch,
    this.onReport,
    this.onBlock,
  }) : super(key: key);

  /// Bottom sheet'i gosteren statik metot
  static Future<void> show({
    required BuildContext context,
    required UserModel matchedUser,
    required String matchId,
    VoidCallback? onUnmatch,
    VoidCallback? onReport,
    VoidCallback? onBlock,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ChatActionsBottomSheet(
        matchedUser: matchedUser,
        matchId: matchId,
        onUnmatch: onUnmatch ?? () => _defaultUnmatch(context, matchId),
        onReport: onReport ?? () => _defaultReport(context, matchedUser),
        onBlock: onBlock ?? () => _defaultBlock(context, matchedUser),
      ),
    );
  }

  static void _defaultUnmatch(BuildContext context, String matchId) {
    // Varsayilan eslesmeyi sonlandirma islemi
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unmatch this person'),
        content: const Text(
            "When you unmatch someone,you won't be able to contact each other or see each other's profiles. If you feel unconfortable, you can also report them. Your safety comes first"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final matchService = MatchService();
                // Eslesmeyi ve iliskili mesajlari sil
                final success = await matchService.deleteMatch(matchId);

                // Dialog'u kapat
                Navigator.pop(context);

                // Sonucu bildir ve sohbet ekranini kapat
                if (success) {
                  Navigator.pop(context); // Sohbet ekranini kapat
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Eslesme basariyla sonlandirildi')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Eslesme sonlandirilirken bir hata olustu')),
                  );
                }
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Hata: $e')),
                );
              }
            },
            child: const Text('Unmatch', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  static void _defaultReport(BuildContext context, UserModel user) {
    // Varsayilan sikayet islemi
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report'),
        content: const Text(
            'Don\'t worry, your feedback is anonymous and they won\'t know that you\'ve blocked or reported them '),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Burada sikayet islemini gerceklestir
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'User has been reported. Thanks for helping us keep Bumble safe.'),
                ),
              );
            },
            child: const Text('Report', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  static void _defaultBlock(BuildContext context, UserModel user) {
    // Varsayilan engelleme islemi
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block'),
        content: const Text('Are you sure you want to block this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Burada engelleme islemini gerceklestir
              Navigator.pop(context);
              Navigator.pop(context); // Sohbet ekranini kapat
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'The user has been blocked. They will no longer be able to send you messages.'),
                ),
              );
            },
            child: const Text('Block', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: UIConstants.paddingMedium,
        horizontal: UIConstants.paddingMedium,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cekme cubugu
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Kullanici bilgileri
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(matchedUser.profilePicture!),
                radius: 30,
                backgroundColor: AppColors.grey,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      matchedUser.name ?? "Unknown User",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Match ID: ${matchId.substring(0, 8)}...',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),

          // Aksiyonlar
          _buildActionItem(
            context: context,
            icon: Icons.person_remove,
            text: 'End match with ${matchedUser.name ?? "User"}',
            color: AppColors.darkYellow,
            onTap: onUnmatch,
          ),
          const SizedBox(height: 16),
          _buildActionItem(
            context: context,
            icon: Icons.flag,
            text: 'Report ${matchedUser.name ?? "User"}',
            color: Colors.red,
            onTap: onReport,
          ),
          const SizedBox(height: 16),
          _buildActionItem(
            context: context,
            icon: Icons.block,
            text: 'Block ${matchedUser.name ?? "Kullanici"}',
            color: Colors.red[700],
            onTap: onBlock,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color? color,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
