import 'package:bumble_clone/common/app_colors.dart';
import 'package:bumble_clone/common/components/profile_components/premium_card/premium_features.dart';
import 'package:flutter/material.dart';

class PremiumCard extends StatefulWidget {
  const PremiumCard({super.key});

  @override
  State<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<PremiumCard> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: MediaQuery.of(context).size.width * 0.88,
      decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.grey,
          ),
          borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: AppColors.darkYellow,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Premium+",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(
                    "Get the VIP treatment, and enjoy better ways to connect with incredible people.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Explore Premium+"),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Perks you'll love:",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                const PremiumFeatures(
                  icon: Icons.lightbulb_rounded,
                  title: 'Get exclusive photo insights',
                  subtitle: "See which photos people love most",
                ),
                const SizedBox(height: 8),
                const PremiumFeatures(
                  icon: Icons.favorite_rounded,
                  title: "See who likes you",
                  subtitle: "Skip the swipes and matches instantly",
                ),
                const SizedBox(height: 8),
                const PremiumFeatures(
                  icon: Icons.people_alt_rounded,
                  title: "Fast-track your likes",
                  subtitle: "Be sooner by people you've liked",
                ),
                const SizedBox(height: 8),
                Visibility(
                  visible: isVisible,
                  child: const Column(
                    children: [
                      PremiumFeatures(
                        icon: Icons.visibility_rounded,
                        title: "Stand out every day",
                        subtitle: "We'll boost your profile at best times",
                      ),
                      SizedBox(height: 8),
                      PremiumFeatures(
                        icon: Icons.filter_list,
                        title: "Fine-tune what you want",
                        subtitle: "Use more filters to get specific",
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isVisible ? "Hide perks" : "See all 5 perks"),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: isVisible
                            ? const Icon(Icons.arrow_upward_rounded)
                            : const Icon(Icons.arrow_downward_rounded))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
