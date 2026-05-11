import 'package:flutter/material.dart';
import 'package:eduline/core/theme/app_colors.dart';
import '../CustomText/custom_text.dart';

class UploadPhotoSection extends StatelessWidget {
  final VoidCallback onChooseFile;

  const UploadPhotoSection({
    super.key,
    required this.onChooseFile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFFE0E0E0), width: 1.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF1A1A1A), width: 1.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.image_outlined,
                  size: 28,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_upward,
                    size: 12,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          CustomText(
            text: 'Upload photo',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.titleText,
          ),
          SizedBox(height: 4),
          CustomText(
            text: 'Upload the front side of your document',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
            color: AppColors.titleText,
          ),
          CustomText(
            text: 'Supports: JPG, PNG, PDF',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
            color: Color(0xFF888888),
          ),
          SizedBox(height: 14),
          OutlinedButton(
            onPressed: onChooseFile,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.outlinedColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            ),
            child: CustomText(
              text: 'Choose a file',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}