import 'dart:ui';
import 'package:get/get.dart';
import 'package:zero_signal/service/storage/storage_key.dart';
import 'package:zero_signal/service/storage/storage_service.dart';

class ChangeLanguageController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _loadLanguage();
  }

  void _loadLanguage() async {
    // Assuming you might add logic here if needed, but GetX locale is usually set in MyApp or main
    // However, if we want to sync the controller state:
    // String? langCode = LocalStorage.preferences?.getString(LocalStorageKeys.languageCode);
    // String? countryCode = LocalStorage.preferences?.getString(LocalStorageKeys.countryCode);
    // if (langCode != null && countryCode != null) {
    // update local state if you have one
    // }
  }

  Future<void> changeLanguage(String languageCode, String countryCode) async {
    var locale = Locale(languageCode, countryCode);
    await Get.updateLocale(locale);

    await LocalStorage.setString(LocalStorageKeys.languageCode, languageCode);
    await LocalStorage.setString(LocalStorageKeys.countryCode, countryCode);
  }
}
