import 'package:flutter/material.dart';
import 'package:eduline/core/theme/app_colors.dart';

class ProductFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;

  const ProductFormTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Color(0xFF8B92A4), fontSize: 16),
        filled: true,
        fillColor: Color(0xFFE7E7E7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: Color(0xFFE7E7E7), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: Color(0xFFE7E7E7), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        suffixIcon: suffixIcon != null
            ? Padding(padding: EdgeInsets.only(right: 16), child: suffixIcon)
            : null,
      ),
    );
  }
}