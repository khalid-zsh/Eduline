import 'package:eduline/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduline/shared/widgets/custom_text.dart';
import 'package:eduline/shared/widgets/custom_button.dart';
import 'package:eduline/shared/widgets/custom_text_field.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = Get.find<AuthController>();

  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool rememberMe = false;
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _savedCredentials();
  }

  void _savedCredentials() {
    if (_authController.rememberMe.value) {
      emailController.text = _authController.savedEmail.value;
      passwordController.text = _authController.savedPassword.value;
      setState(() => rememberMe = true);
    } else {
      emailController.clear();
      passwordController.clear();
      setState(() => rememberMe = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    _authController.handleSignIn(
      emailController.text.trim(),
      passwordController.text,
      remember: rememberMe,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: context.h(5)),
                Image.asset('assets/SignIn/bulb1.png'),
                SizedBox(height: context.h(4)),
                CustomText(
                  text: 'Welcome Back!',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleText,
                ),
                SizedBox(height: context.h(1.5)),
                CustomText(
                  text: 'Please login first to start your Theory Test.',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subtitleText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.h(5)),

                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: 'Email Address',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.titleText,
                  ),
                ),
                SizedBox(height: context.h(1.5)),
                CustomTextField(
                  controller: emailController,
                  hintText: 'pristia@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: context.h(3)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: 'Password',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.titleText,
                  ),
                ),
                SizedBox(height: context.h(1.5)),
                CustomTextField(
                  controller: passwordController,
                  hintText: '••••••••',
                  obscureText: !isPasswordVisible,
                  suffixIcon: GestureDetector(
                    onTap: () =>
                        setState(() => isPasswordVisible = !isPasswordVisible),
                    child: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.outlinedColor,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(height: context.h(2.5)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          setState(() => rememberMe = !rememberMe),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: rememberMe
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              border: Border.all(
                                color: rememberMe
                                    ? AppColors.primaryColor
                                    : AppColors.outlinedColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: rememberMe
                                ? const Icon(Icons.check,
                                color: Colors.white, size: 16)
                                : null,
                          ),
                          SizedBox(width: context.w(2.5)),
                          CustomText(
                            text: 'Remember Me',
                            fontSize: 14,
                            color: AppColors.subtitleText,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Get.toNamed(AppRoutes.forgotPassword),
                      child: CustomText(
                        text: 'Forgot Password',
                        fontSize: 14,
                        color: AppColors.subtitleText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.h(4)),

                Obx(() => _authController.isLoading.value
                    ? const Center(
                    child: CircularProgressIndicator())
                    : CustomButton(
                  title: 'Sign In',
                  color: AppColors.primaryColor,
                  width: double.infinity,
                  onTap: _handleSignIn,
                )),

                SizedBox(height: context.h(2.5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New to Theory Test?',
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF8B92A4)),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.signUp),
                      child: CustomText(
                        text: 'Create Account',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.h(5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}