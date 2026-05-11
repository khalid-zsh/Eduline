import 'package:eduline/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../colors/colors.dart';
import '../../../controller/auth_controller.dart';
import '../../../helper/context_extension.dart';
import '../../widgets/CustomText/custom_text.dart';
import '../../widgets/Custom_Button/custom_button.dart';
import '../../widgets/Custom_TextField/custom_textfield.dart';
import '../../widgets/custom_success_popup/success_popup.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final AuthController _authController = Get.find<AuthController>();
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool isPasswordVisible = false;
  bool hasLettersAndNumbers = false;
  bool hasMinLength = false;
 String? _email;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    passwordController.addListener(_validatePassword);

    if (Get.arguments != null && Get.arguments is Map) {
      _email = Get.arguments['email'];
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    final password = passwordController.text;
    setState(() {
      hasMinLength = password.length >= 8;
      hasLettersAndNumbers =
          password.contains(RegExp(r'[a-zA-Z]')) &&
              password.contains(RegExp(r'[0-9]'));
    });
  }

  Future<void> _handleResetPassword() async {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (_email == null || _email!.isEmpty) {
      Get.snackbar('Error', 'Email is missing. Please restart the process.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (!hasMinLength || !hasLettersAndNumbers) {
      Get.snackbar('Error', 'Password does not meet requirements',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final success = await _authController.resetPassword(
      _email!,
      password,
    );

    if (success) {
      Get.dialog(
        SuccessPopup(
          image: 'assets/SuccessPopup/TodoList.png',
          title: 'Success',
          content: 'Your password is successfully created',
          buttonTitle: 'Continue',
          onTap: () {
            Get.offAllNamed(AppRoutes.login);
          },
        ),
        barrierDismissible: false,
      );
    } else {
      Get.snackbar('Error', 'Password reset failed',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(6),
          ),
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
                    border: Border.all(
                      color: AppColors.outlinedColor,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.black87,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(height: context.h(3)),
              Center(
                child: CustomText(
                  text: 'Reset Password',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleText,
                ),
              ),
              SizedBox(height: context.h(1)),
              Center(
                child: CustomText(
                  text:
                  "Your password must be at least 8 characters\nlong and include a combination of letters,\nnumbers",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subtitleText,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: context.h(5)),
              CustomText(
                text: 'New Password',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.titleText,
              ),
              SizedBox(height: context.h(1.5)),
              CustomTextField(
                controller: passwordController,
                hintText: '••••••••',
                obscureText: !isPasswordVisible,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  child: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.outlinedColor,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(height: context.h(1)),
              CustomText(
                text: 'Confirm New Password',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.titleText,
              ),
              SizedBox(height: context.h(1.5)),
              CustomTextField(
                controller: confirmPasswordController,
                hintText: '••••••••',
                obscureText: !isPasswordVisible,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPasswordVisible =
                      !isPasswordVisible;

                    });
                  },
                  child: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.outlinedColor,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(height: context.h(4)),

              Obx(
                    () => _authController.isLoading.value
                    ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
                    : CustomButton(
                  title: 'Submit',
                  color: AppColors.primaryColor,
                  width: double.infinity,
                  height: context.h(7),
                  onTap: _handleResetPassword,
                ),
              ),

              SizedBox(height: context.h(4)),
            ],
          ),
        ),
      ),
    );
  }
}