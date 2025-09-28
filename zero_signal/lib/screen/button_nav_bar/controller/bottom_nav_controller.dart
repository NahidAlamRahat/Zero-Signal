import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_log/app_log.dart';
import '../../../my_spots_screen/my_spots_screen.dart';
import '../../change_language_screen/change_language_screen.dart';
import '../../create_activity_screen/create_activity_screen.dart';
import '../../edit_profile_screen/edit_profile_screen.dart';
import '../../home_screen/home_screen.dart';
import '../../list_screen/list_screen.dart';
import '../../personal_information_screen/personal_information_screen.dart';
import '../../profile/profile_section_screen.dart';
import '../../save_route/save_route_screen.dart';
import '../../sunset_point_details_screen/sunset_point_details_screen.dart';





class UserBottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  final List<Widget> widgetOptions = [
    const HomeScreen(),
    ActivityListsScreen(),
    const SunsetPointDetailsScreen(),
    const ProfileSectionScreen(),

  ];

  void changeIndex(int index) {
  try{
    selectedIndex.value = index;
    update();
  }catch(e){
    appLog(e) ;
  }
  }
}
