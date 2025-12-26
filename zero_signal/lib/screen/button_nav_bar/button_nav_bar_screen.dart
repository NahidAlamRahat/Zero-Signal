import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import '../../widget/text_widget/text_widgets.dart';
import 'controller/bottom_nav_controller.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 10.h,
              ),
              child: Container(
              
             // height: 60.h,

                decoration: BoxDecoration(
                  color: const Color(0xFF73897E),
                  borderRadius: BorderRadius.circular(40.r),
                ),
                padding: EdgeInsets.symmetric(horizontal:8.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      controller: controller,
                      index: 0,
                      icon: AppIconPath.homeIcon,
                      selectedIcon: AppIconPath.homeIconselect,
                      label: "Explore",
                    ),
                    _buildNavItem(
                      controller: controller,
                      index: 1,
                      icon: AppIconPath.routeIcon,
                      selectedIcon: AppIconPath.routesSelect,
                      label: "Routes",
                    ),
                    _buildNavItem(
                      controller: controller,
                      index: 2,
                      icon: AppIconPath.socialIcon,
                      selectedIcon: AppIconPath.socialSelect,
                      label: "Social",
                    ),
                    _buildNavItem(
                      controller: controller,
                      index: 3,
                      icon: AppIconPath.profileIcon,
                      selectedIcon: AppIconPath.profileSelect,
                      label: "Profile",
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required UserBottomNavController controller,
    required int index,
    required String icon,
    required String selectedIcon,
    required String label,
  }) {
    final isSelected = controller.selectedIndex.value == index;
    
    return GestureDetector(
      onTap: () => controller.changeIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 12.w : 12.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColor.backgroundColor.withOpacity(0.9)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              isSelected ? selectedIcon : icon,
              width: isSelected ? 24.r : 36.r,
              height: isSelected ? 24.r : 36.r,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                width: isSelected ? null : 0,
                child: isSelected
                    ? Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: TextWidget(
                         text: label,
                         
                          fontColor: AppColor.white500,
                        
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
