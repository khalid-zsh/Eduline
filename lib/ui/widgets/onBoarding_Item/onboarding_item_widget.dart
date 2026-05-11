import 'package:eduline/core/theme/app_colors.dart';
import 'package:eduline/features/onboarding/models/onboarding_item.dart';
import 'package:eduline/shared/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class OnboardingItemWidget extends StatelessWidget {
  const OnboardingItemWidget({super.key, required this.items});

  final OnboardingItems items;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        Image.asset(items.image),
        CustomText(
            text: items.title,
          fontSize: 24,
        ),
        CustomText(
          text: items.subtitle,
          fontSize: 14,
          color: AppColors.subtitleText,
          fontWeight: FontWeight.w400,
        )
      ],
    );
  }
}
