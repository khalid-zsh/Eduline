import 'package:eduline/core/theme/app_colors.dart';
import 'package:eduline/core/extensions/context_extension.dart';
import 'package:eduline/routes/app_routes.dart';
import 'package:eduline/shared/widgets/custom_text.dart';
import 'package:eduline/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class EnableLocation extends StatefulWidget {
  const EnableLocation({super.key});

  @override
  State<EnableLocation> createState() => _EnableLocationState();
}

class _EnableLocationState extends State<EnableLocation> {
  bool isLoadingLocation = false;

  Future<void> _handleEnableLocation() async {
    setState(() => isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Error', 'Location services are disabled.',
            backgroundColor: Colors.red, colorText: Colors.white);
        setState(() => isLoadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Error', 'Location permissions denied',
              backgroundColor: Colors.red, colorText: Colors.white);
          setState(() => isLoadingLocation = false);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Error', 'Permissions permanently denied. Open settings.',
            backgroundColor: Colors.red, colorText: Colors.white);
        await Geolocator.openLocationSettings();
        setState(() => isLoadingLocation = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      Placemark place = placemarks.first;
      String currentLocation = "${place.locality}, ${place.country}";

      Get.snackbar('Success', 'Location enabled',
          backgroundColor: Colors.green, colorText: Colors.white);
      Get.toNamed(AppRoutes.language, arguments: currentLocation);
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() => isLoadingLocation = false);
    }
  }

  void _handleSkip() {
    Get.toNamed(AppRoutes.language, arguments: 'Unknown Location');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(height: context.h(30)),
            Image.asset(
              "assets/EnableLocation/Maps.png",
              height: context.h(18),
            ),
            SizedBox(height: context.h(3)),
            CustomText(
              text: "Enable Location",
              color: AppColors.titleText,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: context.h(2)),
            CustomText(
              text: "Kindly allow us to access your location",
              color: AppColors.subtitleText,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(6)),
            GestureDetector(
              onTap: isLoadingLocation ? null : _handleEnableLocation,
              child: CustomButton(
                title: isLoadingLocation ? "Enabling..." : "Enable",
                color: AppColors.primaryColor,
                width: double.infinity,
                isLoading: isLoadingLocation,
              ),
            ),
            SizedBox(height: context.h(2.5)),
            GestureDetector(
              onTap: _handleSkip,
              child: CustomText(
                text: "Skip, Not Now",
                color: AppColors.titleText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}