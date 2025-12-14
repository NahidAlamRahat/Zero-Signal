import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../service/storage/storage_service.dart';
import '../../../utils/app_log/app_log.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    goToNextScreen();
  }

  void goToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    // Load all stored data from SharedPreferences first
    await LocalStorage.getAllPrefData();

    String? accessToken = LocalStorage.token;

    appLog("Access Token: $accessToken");

    if (accessToken != null && accessToken.isNotEmpty) {
      appLog("accessToken.isNotEmpty : ${accessToken.isNotEmpty}");

      Get.offAllNamed(AppRoutes.bottomNav);
    } else {
      Get.offAllNamed(AppRoutes.onboardingScreen);
    }
  }

  @override
  void onClose() {
    super.onClose();
    appLog("SplashController disposed");
  }
}
