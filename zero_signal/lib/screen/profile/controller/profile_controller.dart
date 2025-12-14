import 'package:get/get.dart';
import 'package:zero_signal/utils/app_log/app_log.dart';

import '../../../routes/app_routes.dart';
import '../../../service/storage/storage_service.dart';

class ProfileController extends GetxController {
  final userName = 'Liam Johnson'.obs;
  final userEmail = 'hola@zerosignal.app'.obs;
  final userBio = 'Outdoor enthusiast & explorer'.obs;
  final userPoints = 1540.obs;

  void logout() {
    LocalStorage.removeAllPrefData();
    Get.offAllNamed(AppRoutes.signInScreen);
    appLog('User logged out');
  }

  void navigateToRoute(String routeName, {dynamic arguments}) {
    Get.toNamed(routeName, arguments: arguments);
  }
}