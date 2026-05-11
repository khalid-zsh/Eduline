import 'package:flutter/cupertino.dart';

extension ContextExtension on BuildContext {
  double get screenHeight => MediaQuery.sizeOf(this).height;
  double get screenWidth => MediaQuery.sizeOf(this).width;

  double h(double percent) => screenHeight * (percent / 100);
  double w(double percent) => screenWidth * (percent / 100);
}