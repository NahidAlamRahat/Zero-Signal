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
    // Screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
    final horizontalPadding = isSmallDevice ? 12.0 : isMediumDevice ? 14.0 : 16.0;

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
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: isSmallDevice ? 12 : 10,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: GNav(
                    backgroundColor: AppColor.buttonNavBackgroundColor,
                    gap: navGap,
                    iconSize: navIconSize,
                    padding: EdgeInsets.symmetric(
                      horizontal: navPadding,
                      vertical: navPadding * 0.8, // Increased vertical padding
                    ),
                    tabMargin: _getTabMargin(
                      controller.selectedIndex.value,
                      isSmallDevice ? 6 : 8,
                    ),
                    duration: const Duration(milliseconds: 400),
                    tabBackgroundColor: AppColor.backgroundColor,
                    textStyle: TextStyle(
                      fontSize: fontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    tabBorderRadius: borderRadius,
                    tabs: [
                      _buildGButton(
                        text: 'Explore',
                        isSelected: controller.selectedIndex.value == 0,
                        selectedIcon: AppIconPath.homeIconselect,
                        unselectedIcon: AppIconPath.homeIcon,
                        selectedSize: iconSelectedSize,
                        unselectedSize: iconUnselectedSize,
                      ),
                      _buildGButton(
                        text: 'Routes',
                        isSelected: controller.selectedIndex.value == 1,
                        selectedIcon: AppIconPath.routesSelect,
                        unselectedIcon: AppIconPath.routeIcon,
                        selectedSize: iconSelectedSize,
                        unselectedSize: iconUnselectedSize,
                      ),
                      _buildGButton(
                        text: 'Social',
                        isSelected: controller.selectedIndex.value == 2,
                        selectedIcon: AppIconPath.socialSelect,
                        unselectedIcon: AppIconPath.socialIcon,
                        selectedSize: iconSelectedSize,
                        unselectedSize: iconUnselectedSize,
                      ),
                      _buildGButton(
                        text: 'Profile',
                        isSelected: controller.selectedIndex.value == 3,
                        selectedIcon: AppIconPath.profileSelect,
                        unselectedIcon: AppIconPath.profileIcon,
                        selectedSize: iconSelectedSize,
                        unselectedSize: iconUnselectedSize,
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

  GButton _buildGButton({
    required String text,
    required bool isSelected,
    required String selectedIcon,
    required String unselectedIcon,
    required double selectedSize,
    required double unselectedSize,
  }) {
    return GButton(
      text: text,
      leading: IconWidget(
        icon: isSelected ? selectedIcon : unselectedIcon,
        width: isSelected ? selectedSize : unselectedSize,
        height: isSelected ? selectedSize : unselectedSize,
      ),
      icon: Icons.home,
    );
  }

  EdgeInsets _getTabMargin(int selectedIndex, double margin) {
    if (selectedIndex == 3) {
      return EdgeInsets.only(right: margin);
    } else if (selectedIndex == 0) {
      return EdgeInsets.only(left: margin);
    }
    return EdgeInsets.zero;
  }
}