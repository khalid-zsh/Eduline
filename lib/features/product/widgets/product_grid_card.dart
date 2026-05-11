import 'package:flutter/material.dart';
import 'package:eduline/core/theme/app_colors.dart';
import 'package:eduline/shared/widgets/custom_text.dart';
import 'package:eduline/core/extensions/context_extension.dart';

class CustomGridView extends StatelessWidget {
  final String imageAsset;
  final String category;
  final String title;
  final String price;
  final bool inStock;
  final VoidCallback? onViewDetails;
  final VoidCallback? onEdit;

  const CustomGridView({
    super.key,
    required this.imageAsset,
    required this.category,
    required this.title,
    required this.price,
    this.inStock = true,
    this.onViewDetails,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardColor),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              child: Stack(
                children: [
                  SizedBox.expand(
                    child: imageAsset.startsWith('http')
                        ? Image.network(imageAsset, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]))
                        : Image.asset(imageAsset, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: Colors.grey[300])),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(2),
                        vertical: context.h(0.4),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomText(
                        text: category.toUpperCase(),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6B6B7A),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(2.5),
                        vertical: context.h(0.6),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CustomText(
                        text: price,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(3),
                vertical: context.h(1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.titleText,
                  ),
                  SizedBox(height: context.h(0.5)),
                  Row(
                    children: [
                      const Icon(
                        Icons.check,
                        color: Color(0xFF2ECC71),
                        size: 14,
                      ),
                      SizedBox(width: context.w(1)),
                      CustomText(
                        text: inStock
                            ? 'In Stock'
                            : 'Out of Stock',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: inStock
                            ? Color(0xFF2ECC71)
                            : Colors.red,
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(1)),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: onViewDetails,
                          child: Container(
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: CustomText(
                              text: 'View Details',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: context.w(2)),
                      GestureDetector(
                        onTap: onEdit,
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.subtitleText.withValues(alpha: 0.15),
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: CustomText(
                            text: 'Edit',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.subtitleText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}