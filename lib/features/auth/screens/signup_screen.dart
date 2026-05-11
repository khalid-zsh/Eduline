import 'package:eduline/core/theme/app_colors.dart';
import 'package:eduline/core/constants/app_routes.dart';
import 'package:eduline/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduline/shared/widgets/custom_text.dart';
import '../../../core/extensions/context_extension.dart';
import '../controllers/auth_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthController _authController = Get.find<AuthController>();

  late TextEditingController emailController;
  late TextEditingController fullNameController;
  late TextEditingController passwordController;

  bool isPasswordVisible = false;
  bool hasMinLength = false;
  bool hasLettersAndNumbers = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    fullNameController = TextEditingController();
    passwordController = TextEditingController();
    passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    passwordController.removeListener(_validatePassword);
    passwordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    final pw = passwordController.text;
    setState(() {
      hasMinLength = pw.length >= 8;
      hasLettersAndNumbers = pw.contains(RegExp(r'[a-zA-Z]')) &&
          pw.contains(RegExp(r'[0-9]'));
    });
  }

  void _handleSignUp() {
    final email = emailController.text.trim();
    final name = fullNameController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || name.isEmpty || password.isEmpty) {
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

    if (!hasMinLength || !hasLettersAndNumbers) {
      Get.snackbar('Error', 'Password Requirement Error',
          backgroundColor: Colors.red, colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    _authController.sendOtpAndRegister(name, email, password);
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
              _backButton(),
              SizedBox(height: context.h(3)),
              Center(
                child: CustomText(
                  text: 'Welcome to Eduline',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleText,
                ),
              ),
              SizedBox(height: context.h(1)),
              CustomText(
                text: 'Let’s join to Eduline learning ecosystem & meet\nour professional mentor. It’s Free!',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.subtitleText,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.h(3)),

              _label('Email Address'),
              SizedBox(height: context.h(1.5)),
              CustomTextField(
                  controller: emailController,
                  hintText: 'pristia@gmail.com',
                  keyboardType: TextInputType.emailAddress),
              SizedBox(height: context.h(2.5)),

              // Full Name
              _label('Full Name'),
              SizedBox(height: context.h(1.5)),
              CustomTextField(
                  controller: fullNameController,
                  hintText: 'Pristia Candra'),
              SizedBox(height: context.h(2.5)),

              _label('Password'),
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
              SizedBox(height: context.h(2)),
              _buildStrengthBar(),
              SizedBox(height: context.h(1.5)),
              _buildRequirementRow(
                isValid: hasMinLength && hasLettersAndNumbers,
                text: 'At least 8 characters with a combination of letters\nand numbers',
              ),
              SizedBox(height: context.h(4)),

              Obx(() => _authController.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                width: double.infinity,
                height: context.h(7),
                child: ElevatedButton(
                  onPressed: _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28)),
                    elevation: 0,
                  ),
                  child: CustomText(
                    text: 'Sign Up',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              )),

              SizedBox(height: context.h(2.5)),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'Already have an account?',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.subtitleText,
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.login),
                      child: CustomText(
                        text: 'Sign In',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButton() => GestureDetector(
    onTap: () => Get.back(),
    child: Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
        Border.all(color: AppColors.outlinedColor, width: 1.5),
      ),
      child: Icon(Icons.chevron_left,
          color: Colors.black87, size: 24),
    ),
  );

  Widget _label(String text) => CustomText(
    text: text,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.titleText,
  );

  Widget _buildStrengthBar() {
    int strength = 0;
    if (hasMinLength) strength++;
    if (hasLettersAndNumbers) strength++;
    if (passwordController.text
        .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      strength++;
    }

    Color color() {
      if (passwordController.text.isEmpty) {
        return Color(0xFFDDDFE5);
      }
      if (strength == 1) return Colors.red;
      if (strength == 2) return Colors.orange;
      return Colors.green;
    }

    String label() {
      if (passwordController.text.isEmpty) return '';
      if (strength == 1) return 'weak'.tr;
      if (strength == 2) return 'medium'.tr;
      return 'strong'.tr;
    }

    return Row(
      children: [
        Expanded(
          child: Row(
            children: List.generate(
              3,
                  (i) => Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                  decoration: BoxDecoration(
                    color: i < strength ? color() : Color(0xFFDDDFE5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Text(label(),
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color())),
      ],
    );
  }

  Widget _buildRequirementRow(
      {required bool isValid, required String text}) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isValid
                ? Color(0xFF4CAF50)
                : Colors.transparent,
            border: Border.all(
              color: isValid
                  ? Color(0xFF4CAF50)
                  : Color(0xFFDDDFE5),
              width: 1.5,
            ),
          ),
          child: isValid
              ? Icon(Icons.check, color: Colors.white, size: 12)
              : null,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isValid
                  ? Color(0xFF4CAF50)
                  : Color(0xFF8B92A4),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}