import 'package:eduline/core/constants/app_routes.dart';
import 'package:eduline/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduline/core/theme/app_colors.dart';
import 'package:eduline/features/auth/controllers/auth_controller.dart';
import 'package:eduline/shared/services/preferences_service.dart';
import 'package:eduline/features/product/controllers/product_controller.dart';
import 'package:eduline/features/product/controllers/product_metadata_controller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.instance.init();
  Get.put(AuthController());
  Get.put(ProductController());
  Get.put(ProductMetadataController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      initialRoute: AppRoutes.splash,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
      ),
    );
  }
}