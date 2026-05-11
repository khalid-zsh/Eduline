import 'package:flutter/material.dart';
import '../../../colors/colors.dart';
import '../../../helper/context_extension.dart';
import 'package:eduline/shared/widgets/custom_text.dart';

class CustomTabBar extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CustomTabBar(
      {
        super.key,
        required this.label,
        required this.selected,
        required this.onTap
      }
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(5),
          vertical: context.h(1.2),
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : const Color(0xFFF6F6F8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomText(
          text: label,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : AppColors.titleText,
        ),
      ),
    );
  }
}
