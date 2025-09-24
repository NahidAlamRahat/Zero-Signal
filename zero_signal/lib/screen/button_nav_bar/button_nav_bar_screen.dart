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
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive values
    final double iconSelectedSize = screenWidth * 0.06; // selected অবস্থায়
    final double iconUnselectedSize = screenWidth * 0.09; // unselected অবস্থায়
    final double navPadding = screenWidth * 0.04;
    final double navGap = screenWidth * 0.02;
    final double navIconSize = screenWidth * 0.08;

    return GetBuilder(
      init: UserBottomNavController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.buttonNavBackgroundColor,
          body: IndexedStack(
            index: controller.selectedIndex.value,
            children: controller.widgetOptions,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppColor.buttonNavBackgroundColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: navPadding,
                  vertical: navPadding * 0.6,
                ),
                child: GNav(
                  rippleColor: Colors.grey[300]!,
                  hoverColor: Colors.grey[100]!,
                  gap: navGap,
                  iconSize: navIconSize,
                  padding: EdgeInsets.symmetric(
                    horizontal: navPadding,
                    vertical: navPadding * 0.7,
                  ),
                  duration: const Duration(milliseconds: 400),
                  tabBackgroundColor: AppColor.backgroundColor,
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
        );
      },
    );
  }
}
