import 'package:flutter/material.dart';
import 'package:eduline/core/theme/app_colors.dart';
import 'package:eduline/shared/widgets/custom_text.dart';
import 'package:eduline/core/extensions/context_extension.dart';

class ProductImageCard extends StatelessWidget {
  final String imageAsset;
  final String category;

  const ProductImageCard({
    super.key,
    required this.imageAsset,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          Container(
            height: context.h(24),
            width: double.infinity,
            color: const Color(0xFFF2F3F5),
            child: Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: const Color(0xFFF2F3F5)),
            ),
          ),
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: context.w(3), vertical: context.h(0.5)),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomText(
                text: category.toUpperCase(),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.categoryColor.withOpacity(0.60),
              ),
            ),
          ),
        ],
      ),
    );
  }
}