import 'package:eduline/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/preferences_service_controller.dart';

class OnboardingController extends GetxController {
  late PageController pageController;
  RxInt currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() async {
    if (currentPage.value < 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await PreferencesService.instance.setBool('isSplashFirstTime', true);
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}