import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_log/app_log.dart';
import '../../home_screen/home_screen.dart';
import '../../map_routes_screen/map_routes_screen.dart';
import '../../profile/profile_section_screen.dart';
import '../../social_screen/social_screen.dart';
import '../../profile/controller/profile_controller.dart';

class UserBottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  final List<Widget> widgetOptions = [
    const HomeScreen(),
    MapRoutesScreen(),
    const SocialScreen(),
    ProfileSectionScreen(),
  ];

  void changeIndex(int index) {
    try {
      selectedIndex.value = index;
      if (index == 3) {
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().getProfile();
        }
      }
      update();
    } catch (e) {
      appLog(e);
    }
  }
}
