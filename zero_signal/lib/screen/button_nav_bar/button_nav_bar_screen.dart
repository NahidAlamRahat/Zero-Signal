import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import '../../widget/icon_widget/icon_widget.dart';
import 'controller/bottom_nav_controller.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    // Screen width & height
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive values
    final double iconSelectedSize = screenWidth * 0.06;
    final double iconUnselectedSize = screenWidth * 0.09;
    final double navPadding = screenWidth * 0.04;
    final double navGap = screenWidth * 0.02;
    final double navIconSize = screenWidth * 0.08;

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
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: GNav(
                    backgroundColor: AppColor.buttonNavBackgroundColor,
                    gap: navGap,
                    iconSize: navIconSize,
                    padding: EdgeInsets.symmetric(
                      horizontal: navPadding,
                      vertical: navPadding * 0.7,
                    ),
                    duration: const Duration(milliseconds: 400),
                    tabBackgroundColor: AppColor.backgroundColor, // selected tab bg
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    tabBorderRadius: 40,
                    tabs: [
                      GButton(
                        text: 'Explore',
                        leading: IconWidget(
                          icon: controller.selectedIndex.value == 0
                              ? AppIconPath.homeIconselect
                              : AppIconPath.homeIcon,
                          width: controller.selectedIndex.value == 0
                              ? iconSelectedSize
                              : iconUnselectedSize,
                          height: controller.selectedIndex.value == 0
                              ? iconSelectedSize
                              : iconUnselectedSize,
                        ),
                        icon: Icons.home,
                      ),
                      GButton(
                        text: 'Routes',
                        leading: IconWidget(
                          icon: controller.selectedIndex.value == 1
                              ? AppIconPath.routesSelect
                              : AppIconPath.routeIcon,
                          width: controller.selectedIndex.value == 1
                              ? iconSelectedSize
                              : iconUnselectedSize,
                          height: controller.selectedIndex.value == 1
                              ? iconSelectedSize
                              : iconUnselectedSize,
                        ),
                        icon: Icons.home,

                      ),
                      GButton(
                        text: 'Social',
                        leading: IconWidget(
                          icon: controller.selectedIndex.value == 2
                              ? AppIconPath.socialSelect
                              : AppIconPath.socialIcon,
                          width: controller.selectedIndex.value == 2
                              ? iconSelectedSize
                              : iconUnselectedSize,
                          height: controller.selectedIndex.value == 2
                              ? iconSelectedSize
                              : iconUnselectedSize,
                        ),
                        icon: Icons.home,

                      ),
                      GButton(
                        text: 'Profile',
                        leading: IconWidget(
                          icon: controller.selectedIndex.value == 3
                              ? AppIconPath.profileSelect
                              : AppIconPath.profileIcon,
                          width: controller.selectedIndex.value == 3
                              ? iconSelectedSize
                              : iconUnselectedSize,
                          height: controller.selectedIndex.value == 3
                              ? iconSelectedSize
                              : iconUnselectedSize,
                        ),
                        icon: Icons.home,

                      ),
                    ],
                    selectedIndex: controller.selectedIndex.value,
                    onTabChange: (index) => controller.changeIndex(index),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
