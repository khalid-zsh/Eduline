import 'dart:io';
import 'package:eduline/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:eduline/core/theme/app_colors.dart';
import 'package:eduline/shared/widgets/custom_text.dart';
import 'package:eduline/core/extensions/context_extension.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduline/features/auth/controllers/auth_controller.dart';

Widget homeAppBar(BuildContext context, String location) {
  final authController = Get.find<AuthController>();
  return Container(
    height: context.h(10),
    width: double.infinity,
    padding: EdgeInsets.only(
      left: context.w(5),
      right: context.w(5),
    ),
    decoration: BoxDecoration(
      color: AppColors.primaryColor,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.profile),
        child: Obx(() {
          final user = authController.currentUser.value;
          final imageUrl = user?.profileImage;
          if (imageUrl != null && imageUrl.isNotEmpty && imageUrl.startsWith('http')) {
            return CircleAvatar(radius: 24, backgroundImage: NetworkImage(imageUrl));
          } else {
            return FutureBuilder<String?>(
              future: SharedPreferences.getInstance().then((prefs) => prefs.getString('avatar_path')),
              builder: (context, snapshot) {
                final path = snapshot.data;
                if (path != null && path.isNotEmpty && File(path).existsSync()) {
                  return CircleAvatar(radius: 24, backgroundImage: FileImage(File(path)));
                }
                return CircleAvatar(
                  radius: 24,
                  backgroundImage: const AssetImage("assets/Profile/avatar.jpg") as ImageProvider,
                );
              },
            );
          }
        }),
      ),
      title: Obx(() {
        final user = authController.currentUser.value;
        return CustomText(
          textAlign: TextAlign.start,
          text: user != null && user.fullName.isNotEmpty
              ? 'Hi, ${user.fullName}!'
              : 'Hi there!',
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: AppColors.backgroundColor,
        );
      }),
      subtitle: Row(
        children: [
          Icon(
            Icons.location_on,
            color: AppColors.backgroundColor,
            size: 14,
          ),
          CustomText(
            text: location,
            color: AppColors.backgroundColor,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    ),
  );
}