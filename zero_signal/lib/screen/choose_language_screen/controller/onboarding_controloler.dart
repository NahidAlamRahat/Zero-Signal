import 'package:get/get.dart';

enum Language { english, spanish }

class LanguageController extends GetxController {
  // Private variable for selected language
  Language _selectedLanguage = Language.english;

  // Getter to access selected language
  Language get selectedLanguage => _selectedLanguage;

  // Method to update selected language
  void selectLanguage(Language language) {
    _selectedLanguage = language;

    update();
  }

  // Method to check if a language is selected
  bool isLanguageSelected(Language language) {
    return _selectedLanguage == language;
  }
}