import 'package:eduline/core/constants/app_routes.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../colors/colors.dart';
import '../../../controller/auth_controller.dart';
import '../../../helper/context_extension.dart';
import '../../widgets/CustomText/custom_text.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  bool _isUpdating = false;

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedImage == null) return;

    setState(() => _isUpdating = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatar_path', pickedImage.path);
      setState(() => _isUpdating = false);
      Get.snackbar(
        'Success',
        'Profile image updated',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      setState(() => _isUpdating = false);
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final user = authController.currentUser.value;

    return Scaffold(
      backgroundColor: AppColors.profileColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(6),
                vertical: context.h(2.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFFF2F3F5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, color: Colors.black87),
                    ),
                  ),
                  CustomText(
                    text: 'Profile',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: AppColors.titleText,
                  ),
                  SizedBox(height: context.h(5)),
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: context.w(36),
                              height: context.w(36),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.profileBoxColor,
                              ),
                              child: ClipOval(
                                child: _isUpdating
                                    ? const Center(child: CircularProgressIndicator())
                                    : FutureBuilder<String?>(
                                  future: SharedPreferences.getInstance()
                                      .then((p) => p.getString('avatar_path')),
                                  builder: (context, snapshot) {
                                    final path = snapshot.data;
                                    if (user?.profileImage != null && user!.profileImage!.isNotEmpty) {
                                      return Image.network(
                                        user.profileImage!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.person, size: 48, color: Colors.white54),
                                      );
                                    }
                                    if (path != null && path.isNotEmpty && File(path).existsSync()) {
                                      return Image.file(File(path), fit: BoxFit.cover);
                                    }
                                    return const Icon(Icons.person, size: 48, color: Colors.white54);
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              right: context.w(1),
                              bottom: context.h(1),
                              child: GestureDetector(
                                onTap: _isUpdating ? null : _pickImage,
                                child: Container(
                                  width: context.w(10),
                                  height: context.w(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2F6BFF),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.edit_outlined,
                                    color: Colors.white,
                                    size: context.w(4.5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: context.h(2.5)),
                        CustomText(
                          text: user?.fullName ?? 'User',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.titleText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(height: context.h(2)),
                    _tile(
                      context,
                      Icons.edit_outlined,
                      'Edit Profile',
                          () {
                        Get.toNamed(AppRoutes.setupProfile, arguments: {'isEditMode': true});
                      },
                    ),
                    _divider(context),
                    _tile(
                      context,
                      Icons.settings_outlined,
                      'Support',
                        () => Get.toNamed(AppRoutes.profile),
                    ),
                    _divider(context),
                    _tile(
                      context,
                      Icons.privacy_tip_outlined,
                      'Privacy',
                          () {},
                    ),
                    SizedBox(height: context.h(2)),
                    Container(
                      height: 10,
                      color: const Color(0xFFF3F3F3),
                    ),
                    _tile(
                      context,
                      Icons.logout,
                      'Logout',
                          () {
                        authController.logout();
                      },
                      color: const Color(0xFFFFC107),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback onTap, {
        Color color = const Color(0xFF3B3B3B),
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(6),
          vertical: context.h(2.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: context.w(4)),
            CustomText(
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: context.w(6)),
      height: 1,
      color: const Color(0xFFE9E9E9),
    );
  }
}