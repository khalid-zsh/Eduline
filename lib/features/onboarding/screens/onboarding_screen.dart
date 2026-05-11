import 'package:eduline/core/theme/app_colors.dart';
import 'package:eduline/features/onboarding/controllers/onboarding_controller.dart';
import 'package:eduline/features/onboarding/models/onboarding_item.dart';
import 'package:eduline/features/onboarding/widgets/onboarding_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduline/shared/widgets/custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});
  final OnboardingController controller = Get.put(OnboardingController());

  final List<OnboardingItems> pages = [
    OnboardingItems(
      title: 'Best online courses\nin the world',
      subtitle:
      'Now you can learn anywhere, anytime, even if\nthere is no internet access!',
      image: 'assets/Splash/onboarding.png',
    ),
    OnboardingItems(
      title: 'Explore your new skill today',
      subtitle:
      'Our platform is designed to help you explore\nnew skills. Let\'s learn & grow with Eduline!',
      image: 'assets/Splash/onboarding3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40,),
        child: Column(
          children: [

            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: pages.length,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (context, index) {
                  return OnboardingItemWidget(
                    items: pages[index],
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Obx(
                  () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                      (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 8,
                      width: controller.currentPage.value == index ? 18 : 8,
                      decoration: BoxDecoration(
                        color: controller.currentPage.value == index
                            ? AppColors.primaryColor
                            : Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            Obx(
                  () => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: CustomButton(
                  title: controller.currentPage.value == pages.length - 1 ? 'Get Started' : 'Next',
                  color: AppColors.primaryColor,
                  width: double.infinity,
                  onTap: controller.nextPage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}