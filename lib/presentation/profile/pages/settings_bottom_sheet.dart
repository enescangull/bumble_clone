import 'package:bumble_clone/common/app_colors.dart';
import 'package:bumble_clone/common/bloc_manager.dart';
import 'package:bumble_clone/common/ui_constants.dart';
import 'package:bumble_clone/core/di/service_locator.dart';
import 'package:bumble_clone/domain/repository/user_repository.dart';
import 'package:bumble_clone/presentation/auth/bloc/auth_bloc.dart';
import 'package:bumble_clone/presentation/auth/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Ayarlar alt sayfasi.
///
/// Bu widget, kullanicinin hesabini silme ve cikis yapma gibi
/// ayarlar islemlerini gerceklestirmesini saglar.
class SettingsBottomSheet extends StatelessWidget {
  const SettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final IUserRepository userRepo = getIt<IUserRepository>();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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

          // Baslik
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              "Ayarlar",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Ayarlar Listesi
          _buildSettingItem(
            icon: Icons.person_outline,
            text: "Profil Ayarlari",
            onTap: () {
              Navigator.pop(context);
              // TODO: Profil ayarlari sayfasina yonlendir
            },
          ),

          _buildSettingItem(
            icon: Icons.notifications_none_rounded,
            text: "Bildirim Ayarlari",
            onTap: () {
              Navigator.pop(context);
              // TODO: Bildirim ayarlari sayfasina yonlendir
            },
          ),

          _buildSettingItem(
            icon: Icons.privacy_tip_outlined,
            text: "Gizlilik Ayarlari",
            onTap: () {
              Navigator.pop(context);
              // TODO: Gizlilik ayarlari sayfasina yonlendir
            },
          ),

          _buildSettingItem(
            icon: Icons.help_outline_rounded,
            text: "Yardim ve Destek",
            onTap: () {
              Navigator.pop(context);
              // TODO: Yardim sayfasina yonlendir
            },
          ),

          const Divider(height: 32),

          // Cikis Yap
          _buildSettingItem(
            icon: Icons.logout_rounded,
            text: "Cikis Yap",
            color: AppColors.grey,
            onTap: () {
              Navigator.pop(context);
              _showLogoutConfirmationDialog(context);
            },
          ),

          // Hesabi Sil
          _buildSettingItem(
            icon: Icons.delete_outline_rounded,
            text: "Hesabi Sil",
            color: AppColors.errorRed,
            onTap: () {
              Navigator.pop(context);
              _showDeleteAccountConfirmationDialog(context, userRepo);
            },
          ),

          const SizedBox(height: 8),

          // Uygulama Versiyonu
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "Versiyon 1.0.0",
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? color,
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
            Icon(Icons.chevron_right, color: AppColors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cikis Yap'),
        content: const Text(
            'Hesabinizdan cikis yapmak istediginizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Iptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutEvent(context));
              BlocManager.resetAll(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text('Cikis Yap'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirmationDialog(
      BuildContext context, IUserRepository userRepo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hesabi Sil'),
        content: const Text(
          'Hesabinizi silmek istediginizden emin misiniz? Bu islem geri alinamaz ve tum verileriniz silinecektir.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Iptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              userRepo.deleteAccount();
              BlocManager.resetAll(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
            child: const Text('Hesabi Sil'),
          ),
        ],
      ),
    );
  }
}
