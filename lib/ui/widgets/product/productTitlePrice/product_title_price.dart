import 'package:flutter/material.dart';
import 'package:eduline/core/theme/app_colors.dart';
import 'package:eduline/shared/widgets/custom_text.dart';
import 'package:eduline/core/extensions/context_extension.dart';

class ProductTitlePrice extends StatelessWidget {
  final String title;
  final String price;
  final bool inStock;

  const ProductTitlePrice({
    super.key,
    required this.title,
    required this.price,
    required this.inStock,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText(
                  text: title,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.titleText,
                ),
                SizedBox(width: context.w(2)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.categoryColor.withValues(alpha: 0.80),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: CustomText(
                    text: "active",
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: AppColors.backgroundColor,
                  ),
                )
              ],
            ),
            Row(
              children: [
                const Icon(Icons.check, color: Color(0xFF2ECC71), size: 16),
                SizedBox(width: context.w(1)),
                CustomText(
                  text: inStock ? 'In Stock' : 'Out of Stock',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: inStock ? const Color(0xFF2ECC71) : Colors.red,
                ),
              ],
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText(
              text: price,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            CustomText(
              text: 'Discount: \$10',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.subtitleText,
            ),
          ],
        )
      ],
    );
  }
}