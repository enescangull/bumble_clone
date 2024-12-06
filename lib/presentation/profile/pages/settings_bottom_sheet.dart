import 'package:bumble_clone/common/app_colors.dart';
import 'package:bumble_clone/common/bloc_manager.dart';
import 'package:bumble_clone/core/services/auth_service.dart';
import 'package:bumble_clone/domain/repository/user_repository.dart';
import 'package:bumble_clone/presentation/auth/bloc/auth_bloc.dart';
import 'package:bumble_clone/presentation/auth/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBottomSheet extends StatelessWidget {
  const SettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final IUserRepository _userRepo = IUserRepository();
    return SizedBox(
      height: 150,
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                onPressed: () {
                  _userRepo.deleteAccount();
                  BlocManager.resetAll(context);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.errorRed,
                    ),
                    Text("Delete account"),
                  ],
                )),
            const SizedBox(height: 8),
            OutlinedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutEvent(context));
                  BlocManager.resetAll(context);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      color: AppColors.grey,
                    ),
                    Text("Logout"),
                  ],
                )),
          ],
        ),
      )),
    );
  }
}
