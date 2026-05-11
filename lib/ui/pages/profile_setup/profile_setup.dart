import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:eduline/core/theme/app_colors.dart';
import 'package:eduline/shared/widgets/custom_text.dart';
import 'package:eduline/shared/widgets/custom_button.dart';
import 'package:eduline/core/extensions/context_extension.dart';
import 'package:eduline/core/constants/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/custom_success_popup/success_popup.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final _picker = ImagePicker();

  File? _avatar;
  final _aboutController = TextEditingController();
  final _dobController = TextEditingController();
  String? _selectedGender;

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _aboutController.dispose();
    _dobController.dispose();
    super.dispose();
  }


  Future<void> _pickAvatar(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
      );
      if (file != null) setState(() => _avatar = File(file.path));
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickAvatar(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickAvatar(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year - 10, now.month, now.day),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: AppColors.primaryColor),
        ),
        child: child ?? SizedBox.shrink(),
      ),
    );
    if (picked != null) {
      _dobController.text = DateFormat.yMMMMd().format(picked);
    }
  }


  Future<void> _handleNext() async {
    if (_aboutController.text.trim().isEmpty) {
      Get.snackbar('Validation', 'Please enter About info',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (_dobController.text.trim().isEmpty) {
      Get.snackbar('Validation', 'Please select date of birth',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (_selectedGender == null) {
      Get.snackbar('Validation', 'Please select gender',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatar_path', _avatar?.path ?? '');
    await prefs.setBool('isProfileSetup', true);

    Get.dialog(
      SuccessPopup(
        title: 'Congratulations!',
        content:
        'Your account is ready to use. You will be\nredirected to the home page in a few\nseconds',
        image: '',
        isLoading: true,
      ),
      barrierDismissible: true,
    );
    await Future.delayed(const Duration(seconds: 3));
    if (Get.isDialogOpen ?? false) Get.back();
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.w(5), vertical: context.h(1.5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.h(1)),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.chevron_left, size: 28),
                  ),
                  SizedBox(width: context.w(23)),
                  CustomText(
                    text: 'Set Up Profile',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.titleText,
                  ),
                ],
              ),
              SizedBox(height: context.h(3)),
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _showAvatarOptions,
                      child: CircleAvatar(
                        radius: context.w(12),
                        backgroundColor: Color(0xFFCDCED2),
                        backgroundImage:
                        _avatar != null ? FileImage(_avatar!) : null,
                        child: _avatar == null
                            ? Icon(Icons.person,
                            size: 48, color: Colors.white54)
                            : null,
                      ),
                    ),
                    SizedBox(height: context.h(1.5)),
                    GestureDetector(
                      onTap: _showAvatarOptions,
                      child: CustomText(
                        text: 'Upload profile picture',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.h(3)),
              CustomText(
                text: 'About',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.titleText,
              ),
              SizedBox(height: context.h(1)),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFF9F9FB),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: context.w(4), vertical: context.h(1.8)),
                child: TextField(
                  controller: _aboutController,
                  maxLines: 6,
                  style:
                  TextStyle(color: AppColors.titleText, height: 1.4),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                    'Write something about yourself or your service...',
                    hintStyle: TextStyle(
                        color: AppColors.subtitleText, fontSize: 14),
                  ),
                ),
              ),
              SizedBox(height: context.h(2)),
              CustomText(
                text: 'Date of Birth',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.titleText,
              ),
              SizedBox(height: context.h(1)),
              GestureDetector(
                onTap: _pickDateOfBirth,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.w(4), vertical: context.h(1.6)),
                  decoration: BoxDecoration(
                    color: Color(0xFFF9F9FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _dobController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Date of birth',
                            hintStyle:
                            TextStyle(color: AppColors.subtitleText),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Icon(Icons.calendar_today_outlined,
                          color: AppColors.subtitleText),
                    ],
                  ),
                ),
              ),
              SizedBox(height: context.h(2)),

              CustomText(
                text: 'Gender',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.titleText,
              ),
              SizedBox(height: context.h(1)),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: context.w(4), vertical: context.h(1.2)),
                decoration: BoxDecoration(
                  color: Color(0xFFF9F9FB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedGender,
                    hint: Text('Gender',
                        style:
                        TextStyle(color: AppColors.subtitleText)),
                    isExpanded: true,
                    items: _genders
                        .map((g) => DropdownMenuItem(
                      value: g,
                      child: Text(g,
                          style: TextStyle(
                              color: AppColors.titleText)),
                    ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedGender = v),
                    icon: Icon(Icons.keyboard_arrow_down,
                        color: AppColors.subtitleText),
                  ),
                ),
              ),

              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: context.h(2)),
                child: CustomButton(
                  title: 'Next',
                  color: AppColors.primaryColor,
                  width: double.infinity,
                  onTap: _handleNext,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}