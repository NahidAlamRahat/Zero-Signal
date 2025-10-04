import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constant/app_colors.dart';
import '../../../../constant/app_icon_path.dart';
import '../controller/onboarding_controloler.dart';

class LanguageSelectionWidget extends StatelessWidget {
  const LanguageSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the controller instance
    final LanguageController controller = Get.find<LanguageController>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 0.1,
              child: _buildLanguageButton(
                controller: controller,
                flag: AppIconPath.ukFlag,
                text: 'English',
                language: Language.english,
              ),
            ),
            const SizedBox(height: 15),
            Card(
              elevation: 0.1,
              child: _buildLanguageButton(
                controller: controller,
                flag: AppIconPath.spanishFlag,
                text: 'Spanish/ Espanola',
                language: Language.spanish,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton({
    required LanguageController controller,
    required String flag,
    required String text,
    required Language language,
  }) {
    return GetBuilder<LanguageController>(
      builder: (controller) {
        final isSelected = controller.isLanguageSelected(language);

        return GestureDetector(
          onTap: () {
            controller.selectLanguage(language);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColor.languageSelectedColor
                  : AppColor.languageUnSelectedColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Colors.black.withOpacity(0.1)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Image.asset(flag, height: 20, width: 20),
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
