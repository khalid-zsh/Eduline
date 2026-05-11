import 'package:flutter/material.dart';
import 'package:eduline/core/theme/app_colors.dart';

class ProductFormDropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const ProductFormDropdownField({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFE7E7E7),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Color(0xFFE7E7E7),
          width: 1.5,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(
              color: Color(0xFF8B92A4),
              fontSize: 16,
            ),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF888888)),
          style: TextStyle(fontSize: 16, color: Color(0xFF1A1A1A)),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(20),
          items: items
              .map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}