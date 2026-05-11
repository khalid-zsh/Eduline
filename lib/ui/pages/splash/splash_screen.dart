import 'package:eduline/features/auth/controllers/auth_controller.dart';
import 'package:eduline/shared/services/preferences_service.dart';
import 'package:eduline/core/constants/app_routes.dart';
import 'package:eduline/shared/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:eduline/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helper/context_extension.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    final isOnboardingDone =
    PreferencesService.instance.getBool('isSplashFirstTime');
    if (!isOnboardingDone) {
      Get.offAllNamed(AppRoutes.onBoarding);
      return;
    }

    final authController = Get.find<AuthController>();
    final autoLoggedIn = await authController.tryAutoLogin();
    if (autoLoggedIn) {
      final prefs = await SharedPreferences.getInstance();
      final profileSetup = prefs.getBool('isProfileSetup') ?? false;
      if (profileSetup) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.enableLocation);
      }
      return;
    }
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: context.h(30)),
          Image.asset(
            'assets/Splash/image62.png',
            height: context.h(18),
          ),
          SizedBox(height: context.h(5)),
          CustomText(
            text: 'Theory test in my language',
            color: AppColors.titleText,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: context.h(2)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.w(15)),
            child: CustomText(
              text: 'I must write the real test will be in English\nlanguage and this app just helps you to\nunderstand the materials in your\nlanguage',
              color: AppColors.subtitleText,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: context.h(10)),
          Padding(
            padding: EdgeInsets.only(bottom: context.h(8)),
            child: Lottie.asset(
              'assets/Loading/loading.json',
              height: context.h(10),
              width: context.w(25),
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}