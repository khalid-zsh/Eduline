import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:eduline/core/theme/app_colors.dart';
import 'package:eduline/shared/widgets/custom_text.dart';
import 'package:eduline/shared/widgets/custom_button.dart';

class SuccessPopup extends StatelessWidget {
  final String image;
  final String title;
  final String content;
  final String buttonTitle;
  final VoidCallback? onTap;
  final bool isLoading;

  const SuccessPopup({
    super.key,
    required this.image,
    required this.title,
    required this.content,
    this.buttonTitle = "Continue",
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: image.isNotEmpty ? (isLoading ? Lottie.asset(image, height: 120, repeat: true) : Image.asset(image, height: 120)) : null,
      title: CustomText(
        text: title,
        fontWeight: FontWeight.w600,
        fontSize: 24,
        color: AppColors.titleText,
        textAlign: TextAlign.center,
      ),

      content: CustomText(
        text: content,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: AppColors.titleText,
        textAlign: TextAlign.center,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      backgroundColor: AppColors.backgroundColor,

      actions: [
        if (isLoading)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Center(
              child: Lottie.asset(
                'assets/Loading/loading.json',
                height: 60,
              ),
            ),
          )
        else
          CustomButton(
            title: buttonTitle,
            color: AppColors.primaryColor,
            width: double.infinity,
            onTap: onTap ?? () => Get.back(),
          )
      ],
    );
  }
}