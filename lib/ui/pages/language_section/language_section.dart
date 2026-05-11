import 'package:eduline/core/theme/app_colors.dart';
import 'package:eduline/core/extensions/context_extension.dart';
import 'package:eduline/core/constants/app_routes.dart';
import 'package:eduline/shared/widgets/custom_text.dart';
import 'package:eduline/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Language {
  final String name;
  final String flag;
  final Locale locale;
  final String languageCode;

  Language({
    required this.name,
    required this.flag,
    required this.locale,
    required this.languageCode,
  });
}

class LanguageSelectionScreen extends StatefulWidget{
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  int _selectedIndex = 0;

  final List<Language> _languages = [
    Language(
      name: 'English (US)',
      flag: '🇺🇸',
      locale: const Locale('en', 'US'),
      languageCode: 'en',
    ),
    Language(
      name: 'Indonesia',
      flag: '🇮🇩',
      locale: const Locale('id', 'ID'),
      languageCode: 'id',
    ),
    Language(
      name: 'Afghanistan',
      flag: '🇦🇫',
      locale: const Locale('ps', 'AF'),
      languageCode: 'ps',
    ),
    Language(
      name: 'Algeria',
      flag: '🇩🇿',
      locale: const Locale('ar', 'DZ'),
      languageCode: 'ar',
    ),
    Language(
      name: 'Malaysia',
      flag: '🇲🇾',
      locale: const Locale('ms', 'MY'),
      languageCode: 'ms',
    ),
    Language(
      name: 'Arabic',
      flag: '🇦🇪',
      locale: const Locale('ar', 'AE'),
      languageCode: 'ar',
    ),
  ];

  Future<void> _handleContinue() async {
    final selected = _languages[_selectedIndex];
    Get.updateLocale(selected.locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', selected.languageCode);
    Get.snackbar('Success', 'Language changed to ${selected.name}',
        backgroundColor: Colors.green, colorText: Colors.white);
    Get.toNamed(AppRoutes.setupProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.h(1.5)),
            CustomText(
              text: "What is Your Mother Language",
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.titleText,
            ),
            SizedBox(height: context.h(1.5)),
            CustomText(
              text: "Discover what is a podcast description and podcast summary.",
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.subtitleText,
              maxLines: 2,
            ),
            SizedBox(height: context.h(3.5)),
            Expanded(
              child: ListView.builder(
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          )
                        ] : [],
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFF3F4F6),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _languages[index].flag,
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                          const SizedBox(width: 15),

                          Expanded(
                            child: Text(
                              _languages[index].name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F1F1F),
                              ),
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF1E6AFE) : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                if (isSelected)
                                  const Icon(Icons.check, color: Colors.white, size: 16),
                                if (isSelected) const SizedBox(width: 5),
                                Text(
                                  isSelected ? "Selected" : "Select",
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: context.h(3)),
              child: CustomButton(
                title: "Continue",
                color: AppColors.primaryColor,
                width: double.infinity,
                onTap: _handleContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


