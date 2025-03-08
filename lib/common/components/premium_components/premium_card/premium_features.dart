import 'package:bumble_clone/common/app_colors.dart';
import 'package:flutter/material.dart';

class PremiumFeatures extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const PremiumFeatures({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
              color: AppColors.black, shape: BoxShape.circle),
          child: Icon(
            icon,
            color: AppColors.background,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
            ),
          ],
        )
      ],
    );
  }
}
