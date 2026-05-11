import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final String ? title;
  final Color ? color;
  final double ? width;
  final double ? height;
  final void Function() ? onTap;
  final bool ? isLoading;

  const CustomButton(
      {
        super.key,
        required this.title,
        required this.color,
        required this.width,
        this.onTap,
        this.height,
        this.isLoading
      }
      );


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? size.width * 0.9,
        height: height,
        padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            title!,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
