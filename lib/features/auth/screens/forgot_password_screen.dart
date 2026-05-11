import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../colors/colors.dart';
import '../../../controller/auth_controller.dart';
import '../../../helper/context_extension.dart';
import 'package:eduline/shared/widgets/custom_text.dart';
import 'package:eduline/shared/widgets/custom_text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final AuthController _authController = Get.find<AuthController>();
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar('Error', 'Fill All Fields',
          backgroundColor: Colors.red, colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      Get.snackbar('Error', 'Enter a valid email address',
          backgroundColor: Colors.red, colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    _authController.sendOtpForForgotPassword(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(6)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.h(2)),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                    Border.all(color: AppColors.outlinedColor, width: 1.5),
                  ),
                  child: const Icon(Icons.chevron_left,
                      color: Colors.black87, size: 24),
                ),
              ),
              SizedBox(height: context.h(3)),
              Center(
                child: CustomText(
                  text: 'Forgot Password',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleText,
                ),
              ),
              SizedBox(height: context.h(1)),
              Center(
                child: CustomText(
                  text: 'Enter your email, we will send a\nverification code to email',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subtitleText,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: context.h(3)),
              CustomText(
                text: 'Email Address',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.titleText,
              ),
              SizedBox(height: context.h(1.5)),
              CustomTextField(
                controller: emailController,
                hintText: 'pristia@gmail.com',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: context.h(3)),
              Obx(() => _authController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                width: double.infinity,
                height: context.h(7),
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28)),
                    elevation: 0,
                  ),
                  child: CustomText(
                    text: 'Continue',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}