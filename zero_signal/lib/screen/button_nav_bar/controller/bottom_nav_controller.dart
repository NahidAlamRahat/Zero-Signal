import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_log/app_log.dart';
import '../../home_screen/home_screen.dart';
import '../../sport_details/sport_details_screen.dart';





class UserBottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  final List<Widget> widgetOptions = [
    const HomeScreen(),
    const SpotDetailsScreen(),
    const HomeScreen(),
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
