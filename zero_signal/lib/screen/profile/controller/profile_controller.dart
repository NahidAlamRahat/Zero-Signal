import 'package:get/get.dart';
import 'package:zero_signal/utils/app_log/app_log.dart';

import '../../../routes/app_routes.dart';
import '../../../service/storage/storage_service.dart';
import '../../../repository/profile_repository.dart';
import '../model/profile_model.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();
  final userName = 'User Name'.obs;
  final userEmail = 'user@email.com'.obs;
  final userBio = 'Outdoor enthusiast & explorer'.obs;
  final userPoints = 0.obs;
  final userImage = ''.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }

  Future<void> getProfile() async {
    isLoading.value = true;
    ProfileModel? profileModel = await _profileRepository.getProfileData();
    if (profileModel != null && profileModel.data != null) {
      userName.value = profileModel.data?.name ?? "";
      userEmail.value = profileModel.data?.email ?? "";
      userBio.value = profileModel.data?.meInOneSentence ?? "";
      userImage.value = profileModel.data?.image ?? "";
    }
    isLoading.value = false;
  }

  void logout() {
    LocalStorage.removeAllPrefData();
    Get.offAllNamed(AppRoutes.signInScreen);
    appLog('User logged out');
  }

  void navigateToRoute(String routeName, {dynamic arguments}) {
    Get.toNamed(routeName, arguments: arguments);
  }
}
