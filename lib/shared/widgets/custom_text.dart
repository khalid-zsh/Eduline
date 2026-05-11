import 'package:flutter/cupertino.dart';

import '../../core/theme/app_colors.dart';

class CustomText extends StatelessWidget {

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;


  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 24,
    this.fontWeight = FontWeight.w800,
    this.textAlign = TextAlign.center,
    this.color,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color: color ?? AppColors.titleText,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}