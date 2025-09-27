import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_log/app_log.dart';
import '../../filters_screen/filters_screen.dart';
import '../../home_screen/home_screen.dart';
import '../../map_routes_screen/map_routes_screen.dart';
import '../../save_route/save_route_screen.dart';
import '../../sport_details/sport_details_screen.dart';
import '../../update_information_screen/update_information_screen.dart';





class UserBottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  final List<Widget> widgetOptions = [
    const HomeScreen(),
    FiltersScreen(),
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
