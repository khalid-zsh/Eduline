import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduline/core/theme/app_colors.dart';
import 'package:eduline/shared/widgets/custom_text.dart';
import 'package:eduline/core/extensions/context_extension.dart';

class ProductTopBar extends StatelessWidget {
  const ProductTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(4), vertical: context.h(1)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFF2F3F5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black87),
            ),
          ),
          const Spacer(),
          CustomText(
            text: 'Service Detail',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.titleText,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              // delete action
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFFFECEC),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete, color: Color(0xFFE53935)),
            ),
          ),
        ],
      ),
    );
  }
}