import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_log/app_log.dart';
import '../../create_activity_screen/create_activity_screen.dart';
import '../../home_screen/home_screen.dart';
import '../../list_screen/list_screen.dart';
import '../../save_route/save_route_screen.dart';





class UserBottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  final List<Widget> widgetOptions = [
    const HomeScreen(),
    ActivityListsScreen(),
    const SaveRouteScreen(),
    const HomeScreen(),

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
