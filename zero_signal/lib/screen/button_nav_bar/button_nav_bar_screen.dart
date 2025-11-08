import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';
import '../../widget/icon_widget/icon_widget.dart';
import 'controller/bottom_nav_controller.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final isSmallDevice = screenWidth < 360;
    final isMediumDevice = screenWidth >= 360 && screenWidth < 600;
    final isLargeDevice = screenWidth >= 600;

    // Responsive calculations
    late double iconSelectedSize;
    late double iconUnselectedSize;
    late double navPadding;
    late double navGap;
    late double navIconSize;
    late double fontSize;
    late double borderRadius;

    if (isSmallDevice) {
      // Small devices (< 360px)
      iconSelectedSize = screenWidth * 0.05;
      iconUnselectedSize = screenWidth * 0.07;
      navPadding = screenWidth * 0.03;
      navGap = screenWidth * 0.01;
      navIconSize = screenWidth * 0.065;
      fontSize = screenWidth * 0.03;
      borderRadius = 35;
    } else if (isMediumDevice) {
      // Medium devices (360-600px)
      iconSelectedSize = screenWidth * 0.055;
      iconUnselectedSize = screenWidth * 0.075;
      navPadding = screenWidth * 0.040;
      navGap = screenWidth * 0.015;
      navIconSize = screenWidth * 0.07;
      fontSize = screenWidth * 0.032;
      borderRadius = 38;
    } else {
      // Large devices (> 600px)
      iconSelectedSize = screenWidth * 0.12;
      iconUnselectedSize = screenWidth * 0.09;
      navPadding = screenWidth * 0.04;
      navGap = screenWidth * 0.02;
      navIconSize = screenWidth * 0.08;
      fontSize = screenWidth * 0.035;
      borderRadius = 40;
    }

    // Responsive padding
    final horizontalPadding = isSmallDevice ? 12.0 : isMediumDevice
        ? 14.0
        : 16.0;

    return GetBuilder(
      init: UserBottomNavController(),
      builder: (controller) {
        return Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: controller.selectedIndex.value,
            children: controller.widgetOptions,
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                  color: controller.selectedIndex.value == 1 ? AppColor
                      .creamBackgroundColor : Colors.transparent
              ),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: isSmallDevice ? 12 : 10,
              ),
              child: Container(
                width: Get.width,

                color: Colors.red,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    InkWell(

                        onTap: (){

                          controller.changeIndex(0);
                        },
                        child: TextWidget(
                            fontColor: controller.selectedIndex.value == 0 ? AppColor.green : AppColor.textColor,
                            text: "Home")),

                    InkWell(

                        onTap: (){

                          controller.changeIndex(1);
                        },
                        child: TextWidget(
                            fontColor: controller.selectedIndex.value == 1 ? AppColor.green : AppColor.textColor,

                            text: "Home1")),

                    InkWell(

                        onTap: (){

                          controller.changeIndex(2);
                        },
                        child: TextWidget(

                            fontColor: controller.selectedIndex.value == 2 ? AppColor.green : AppColor.textColor,

                            text: "Home2")),

                    InkWell(

                        onTap: (){

                          controller.changeIndex(3);
                        },
                        child: TextWidget(

                            fontColor: controller.selectedIndex.value == 3 ? AppColor.green : AppColor.textColor,

                            text: "Home3")),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


}
