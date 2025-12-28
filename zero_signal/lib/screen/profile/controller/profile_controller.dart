import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zero_signal/repository/route_repository/route_repository.dart';
import 'package:zero_signal/widget/app_snack_bar/app_snack_bar.dart';
import 'package:zero_signal/utils/app_log/app_log.dart';

import '../../../routes/app_routes.dart';
import '../../../service/storage/storage_service.dart';
import '../../../repository/profile_repository.dart';
import '../model/profile_model.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();
  final userName = 'User Name'.obs;
  final userEmail = 'user@email.com'.obs;
  final oneLineBio = 'Outdoor enthusiast & explorer'.obs;
  final userPoints = 0.obs;
  final userImage = ''.obs;
  final userGender = 'Male'.obs;
  final userDob = '17 dec, 2024'.obs;
  final userAddress = '297 Westheimer Rd. Santa Ana'.obs;
  final bio = ''.obs;
  final isLoading = false.obs;

  final TextEditingController passwordController = TextEditingController();
  final RouteRepository _routeRepository = RouteRepository();

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
      oneLineBio.value = profileModel.data?.meInOneSentence ?? "";
      userImage.value = profileModel.data?.image ?? "";
      userGender.value = profileModel.data?.gender ?? "";
      userDob.value = profileModel.data?.dateOfBirth ?? "";
      userAddress.value = profileModel.data?.address ?? "";
      bio.value = profileModel.data?.bio ?? "";
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

  Future<void> deleteAccount(BuildContext context) async {
    if (passwordController.text.isEmpty) {
      AppSnackBar.error("Please enter your password");
      return;
    }

    isLoading.value = true;
    bool success =
        await _routeRepository.deleteAccount(passwordController.text);
    isLoading.value = false;

    if (success) {
      AppSnackBar.success("Account deleted successfully");
      logout();
    } else {
      AppSnackBar.error(
          "Failed to delete account. Please check your password.");
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }
}
