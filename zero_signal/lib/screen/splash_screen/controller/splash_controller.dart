
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_log/app_log.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    goToNextScreen();
  }

  void goToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    // String? accessToken = LocalStorage.token;
    // String? role = LocalStorage.myRole;

    // appLog("Access Token: $accessToken");
    // appLog("Role: $role");

/*    if (accessToken != null && accessToken.isNotEmpty) {
      appLog("accessToken.isNotEmpty : ${accessToken.isNotEmpty}");



      if (role == "user") {
        Get.offAllNamed(AppRoutes.userBottomNav);
      } else if (role == "business") {
        Get.offAllNamed(AppRoutes.businessBottomNav);
      } else {
        Get.offAllNamed(AppRoutes.onboardingScreen);
      }
    } else {
      Get.offAllNamed(AppRoutes.onboardingScreen);
    }*/


    Get.offAllNamed(AppRoutes.onBoardingScreen);



  }

  @override
  void onClose() {
    super.onClose();
    appLog("SplashController disposed");
  }
}