import 'package:eduline/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:eduline/shared/widgets/custom_text.dart';

class FormSection extends StatelessWidget {
  final String label;
  final Widget child;

  const FormSection({
    super.key,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: CustomText(
            text: label,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.left,
            color: AppColors.titleText,
          ),
        ),
        child,
        SizedBox(height: 20),
      ],
    );
  }
}