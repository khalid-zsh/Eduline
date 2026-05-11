import 'dart:async';
import 'package:eduline/core/theme/app_colors.dart';
import 'package:eduline/features/auth/controllers/auth_controller.dart';
import 'package:eduline/core/constants/app_routes.dart';
import 'package:eduline/shared/widgets/custom_text.dart';
import 'package:eduline/shared/widgets/custom_button.dart';
import 'package:eduline/shared/widgets/success_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/extensions/context_extension.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final AuthController _authController = Get.find<AuthController>();

  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  late Timer _timer;
  late String _email;
  late String _flowType;

  int _secondsRemaining = 60;
  bool _canResend = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(4, (_) => FocusNode());
    _controllers = List.generate(4, (_) => TextEditingController());

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    _email = args['email'] as String? ?? '';
    _flowType = args['flowType'] as String? ?? 'signup';

    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    for (final n in _focusNodes) {
      n.dispose();
    }
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          t.cancel();
        }
      });
    });
  }

  void _handleResend() {
    if (!_canResend) return;
    _authController.resendOtp(_email, _flowType);
    _timer.cancel();
    _startTimer();
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
  }

  Future<void> _handleVerify() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length < 4) {
      Get.snackbar('Error', 'Enter All Digits',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (_email.isEmpty) {
      Get.snackbar('Error', 'Email is missing',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => _isVerifying = true);
    try {
      final otp = int.parse(code);

      if (_flowType == 'signup') {
        await _authController.verifyOtpSignup(_email, otp);
        if (mounted) _showSuccessPopup();
      } else {
        await _authController.verifyOtpForgotPassword(_email, otp);
        Get.offNamed(AppRoutes.resetPassword,
            arguments: {'email': _email});
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SuccessPopup(
        image: 'assets/SuccessPopup/Success.png',
        title: 'Successfully Registered',
        content:
        'Your account has been registered\nsuccessfully, now let’s enjoy our features!',
        buttonTitle: 'Continue',
          onTap: () async {
            Get.back();
            await Future.delayed(Duration(milliseconds: 200));
            Get.offAllNamed(AppRoutes.enableLocation);
          }
      ),
    );
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
              SizedBox(height: context.h(3)),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.outlinedColor, width: 1.5),
                  ),
                  child: const Icon(Icons.chevron_left,
                      color: Colors.black87, size: 24),
                ),
              ),
              SizedBox(height: context.h(6)),
              Center(
                child: CustomText(
                  text: 'Verify Code',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleText,
                ),
              ),
              SizedBox(height: context.h(2)),

              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Please enter the code we just sent to\nemail ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.subtitleText,
                        ),
                      ),
                      TextSpan(
                        text: _email,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.titleText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: context.h(6)),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                      (i) => _buildOtpField(index: i),
                ),
              ),

              SizedBox(height: context.h(8)),

              Center(
                child: GestureDetector(
                  onTap: _handleResend,
                  child: CustomText(
                    text: _canResend
                        ? 'Resend code'
                        : '${'Resend Code In'.tr}00:${_secondsRemaining.toString().padLeft(2, '0')}',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: _canResend
                        ? AppColors.primaryColor
                        : AppColors.subtitleText,
                  ),
                ),
              ),

              SizedBox(height: context.h(4)),

              _isVerifying
                  ? Center(
                  child: CircularProgressIndicator(
                      color: AppColors.primaryColor))
                  : CustomButton(
                title: 'Verify',
                color: AppColors.primaryColor,
                width: double.infinity,
                height: context.h(7),
                onTap: _handleVerify,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField({required int index}) {
    return Container(
      width: context.w(15),
      height: context.h(10),
      margin: EdgeInsets.symmetric(horizontal: context.w(2)),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (value) {
          if (value.length > 1) {
            _controllers[index].text = value[value.length - 1];
          }
          if (_controllers[index].text.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          } else if (_controllers[index].text.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
        decoration: InputDecoration(
          counterText: '',
          hintText: '•',
          hintStyle: const TextStyle(
              color: Colors.black, fontSize: 32, fontWeight: FontWeight.w600),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
            BorderSide(color: AppColors.outlinedColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
            BorderSide(color: AppColors.outlinedColor, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
            BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
      ),
    );
  }
}