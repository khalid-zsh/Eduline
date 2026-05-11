import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduline/features/auth/data/auth_remote_data_source.dart';
import 'package:eduline/shared/services/auth_storage.dart';
import 'package:eduline/features/auth/models/user_model.dart';
import 'package:eduline/routes/app_routes.dart';
import 'dart:io';

class AuthController extends GetxController {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();

  final isLoggedIn = false.obs;
  final isLoading = false.obs;
  final rememberMe = false.obs;
  final savedEmail = ''.obs;
  final savedPassword = ''.obs;
  final currentUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    isLoggedIn.value = token.isNotEmpty;
    rememberMe.value = prefs.getBool('remember_me') ?? false;
    if (rememberMe.value) {
      savedEmail.value = prefs.getString('saved_email') ?? '';
      savedPassword.value = prefs.getString('saved_password') ?? '';
    }
    if (token.isNotEmpty) {
      await fetchCurrentUser();
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final remember = prefs.getBool('remember_me') ?? false;
    if (token.isNotEmpty && remember) {
      isLoggedIn.value = true;
      await fetchCurrentUser();
      return true;
    }
    return false;
  }


  Future<void> fetchCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      currentUser.value = user;
    } catch (_) {
    }
  }

  Future<void> handleSignIn(
      String email,
      String password, {
        bool remember = false,
      }) async {
    if (email.isEmpty || password.isEmpty) {
      _showError('Validation', 'Fill all fields');
      return;
    }
    isLoading.value = true;
    try {
      final token = await _remoteDataSource.login(email.trim(), password);


      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      await prefs.setBool('remember_me', remember);
      if (remember) {
        await prefs.setString('saved_email', email);
        await prefs.setString('saved_password', password);
      }
      isLoggedIn.value = true;
      await fetchCurrentUser();
      Get.offAllNamed(AppRoutes.enableLocation);
    } catch (e) {
      _showError('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> sendOtpAndRegister(
      String fullName,
      String email,
      String password,
      ) async {
    isLoading.value = true;
    try {
      await _remoteDataSource.register(fullName.trim(), email.trim(), password);
      await _remoteDataSource.resendOtp(email.trim());
      Get.toNamed(AppRoutes.verifyCode, arguments: {
        'email': email.trim(),
        'flowType': 'signup',
      });
    } catch (e) {
      _showError('Registration Failed', e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> sendOtpForForgotPassword(String email) async {
    if (email.trim().isEmpty) {
      _showError('Validation Error', 'Please enter your email');
      return;
    }
    isLoading.value = true;
    try {
      await _remoteDataSource.forgotPassword(email.trim());
      Get.toNamed(AppRoutes.verifyCode, arguments: {
        'email': email.trim(),
        'flowType': 'forgotPassword',
      });
    } catch (e) {
      _showError('Error', e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> verifyOtpSignup(String email, int otp) async {
    isLoading.value = true;
    try {
      final token = await _remoteDataSource.verifyOtp(email, otp);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      isLoggedIn.value = true;
      await fetchCurrentUser();
      final isProfileSetup = prefs.getBool('isProfileSetup') ?? false;
      if (isProfileSetup) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.enableLocation);
      }
    } catch (e) {
      _showError('Verification Failed', e.toString().replaceFirst('Exception: ', ''));
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> verifyOtpForgotPassword(String email, int otp) async {
    isLoading.value = true;
    try {
      final token = await _remoteDataSource.verifyOtp(email, otp);
      if (token.isEmpty) throw Exception('Invalid reset token');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AuthStorage.resetToken, token);
      Get.offNamed(AppRoutes.resetPassword, arguments: {'email': email});
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> resendOtp(String email, String flowType) async {
    isLoading.value = true;
    try {
      if (flowType == 'forgotPassword') {
        await _remoteDataSource.forgotPassword(email);
      } else {
        await _remoteDataSource.resendOtp(email);
      }
      Get.snackbar(
        'Success',
        'OTP resent to $email',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _showError('Error', e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }


  Future<bool> resetPassword(String email, String newPassword) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AuthStorage.resetToken);
      if (token == null || token.isEmpty) throw Exception('Reset token missing');
      await _remoteDataSource.resetPassword(email, newPassword, token);
      await prefs.remove(AuthStorage.resetToken);
      return true;
    } catch (e) {
      _showError('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> completeProfile({
    required String aboutUs,
    required String dateOfBirth,
    required String gender,
    File? image,
  }) async {
    isLoading.value = true;
    try {
      await _remoteDataSource.completeProfile(
        aboutUs: aboutUs,
        dateOfBirth: dateOfBirth,
        gender: gender,
        image: image,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isProfileSetup', true);
      if (image != null) await prefs.setString('avatar_path', image.path);
      await fetchCurrentUser();
    } catch (e) {
      _showError('Error', e.toString().replaceFirst('Exception: ', ''));
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> updateProfile({
    required String fullName,
    required String aboutUs,
    required String dateOfBirth,
    required String gender,
    File? image,
  }) async {
    isLoading.value = true;
    try {
      final updated = await _remoteDataSource.updateProfile(
        fullName: fullName,
        aboutUs: aboutUs,
        dateOfBirth: dateOfBirth,
        gender: gender,
        image: image,
      );
      currentUser.value = updated;
      if (image != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('avatar_path', image.path);
      }
    } catch (e) {
      _showError('Error', e.toString().replaceFirst('Exception: ', ''));
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> updateProfileImage(File image) async {
    isLoading.value = true;
    try {
      final user = currentUser.value;
      final updated = await _remoteDataSource.updateProfile(
        fullName: user?.fullName ?? '',
        aboutUs: user?.aboutUs ?? '',
        dateOfBirth: user?.dateOfBirth ?? '',
        gender: user?.gender ?? '',
        image: image,
      );
      currentUser.value = updated;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatar_path', image.path);
    } catch (e) {
      _showError('Error', e.toString().replaceFirst('Exception: ', ''));
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('reset_token');
    await prefs.remove('isProfileSetup');
    await prefs.remove('avatar_path');
    await prefs.remove('saved_email');
    await prefs.remove('saved_password');
    await prefs.setBool('remember_me', false);

    savedEmail.value = '';
    savedPassword.value = '';
    rememberMe.value = false;
    currentUser.value = null;
    isLoggedIn.value = false;

    Get.offAllNamed(AppRoutes.login);
  }

  void _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }
}