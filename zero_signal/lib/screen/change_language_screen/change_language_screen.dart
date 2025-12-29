import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/screen/change_language_screen/controller/change_language_controller.dart';
import 'package:zero_signal/utils/app_log/app_log.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  final ChangeLanguageController controller =
      Get.put(ChangeLanguageController());
  String selectedLanguage = 'English'; // Default selected language

  @override
  void initState() {
    super.initState();
    // Set initial selection based on current locale
    if (Get.locale?.languageCode == 'es') {
      selectedLanguage = 'Español / Spanish';
    } else {
      selectedLanguage = 'English';
    }
  }

  final List<LanguageOption> languages = [
    LanguageOption(
      code: 'en',
      countryCode: 'US',
      name: 'English',
      flagPath: AppIconPath.ukFlag,
    ),
    LanguageOption(
      code: 'es',
      countryCode: 'ES',
      name: 'Español / Spanish',
      flagPath: AppIconPath.spanishFlag,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E9),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Language List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: languages
                      .map((language) => _buildLanguageOption(language))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              size: 24,
              color: Color(0xFF2C2C2C),
            ),
          ),
          Expanded(
            child: Text(
              AppStrings.changeLanguageHeader,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF2C2C2C),
                fontSize: 20,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 24), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildLanguageOption(LanguageOption language) {
    final bool isSelected = selectedLanguage == language.name;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedLanguage =
                language.name; // Keep this to update selection UI
          });
          _onLanguageSelected(language);
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF5E9DF) : Colors.transparent,
            border: Border.all(
              color: const Color(0xFFF5E9DF),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // Flag
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(language.flagPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Language name
              Expanded(
                child: Text(
                  language.name,
                  style: TextStyle(
                    color: const Color(0xFF2C2C2C),
                    fontSize: 16,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Selection indicator
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF2E4F3E),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLanguageSelected(LanguageOption language) {
    // Handle language selection
    appLog('Language selected: ${language.name} (${language.code})',
        source: 'ChangeLanguageScreen');

    controller.changeLanguage(language.code, language.countryCode);

    // Example: Show confirmation and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppStrings.languageChangedPrefix}${language.name}'),
        backgroundColor: const Color(0xFF2E4F3E),
        duration: const Duration(seconds: 2),
      ),
    );

    // Navigate back after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pop(context, language);
      }
    });
  }
}

class LanguageOption {
  final String code;
  final String countryCode;
  final String name;
  final String flagPath;

  LanguageOption({
    required this.code,
    required this.countryCode,
    required this.name,
    required this.flagPath,
  });
}
