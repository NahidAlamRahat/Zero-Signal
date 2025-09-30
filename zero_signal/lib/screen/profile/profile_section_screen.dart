import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/routes/app_routes.dart';

import '../../constant/app_icon_path.dart';
import '../../widget/icon_widget/icon_widget.dart';
import '../../widget/space_widget.dart';
import '../../widget/text_widget/text_widgets.dart';

class ProfileSectionScreen extends StatelessWidget {
  const ProfileSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 46),
        child: Column(
          spacing: 16,
          children: [
            // Profile Card
            _buildProfileCard(),

            // Menu Items Card
            _buildMenuItemsCard(context),

            // Settings Card
            _buildSettingsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: 390.w,
      height: 146.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5E9DF),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0x23000000),
            blurRadius: 4,
            offset: const Offset(0, 0),
          )
        ],
      ),
      child: Column(
        children: [
          // Profile Image
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.personalInformationScreen);
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFFCB20), width: 2),
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: AssetImage(AppImagePath.profileImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Name
          Text(
            'Liam Johnson',
            style: TextStyle(
              color: const Color(0xFF2C2C2C),
              fontSize: 12.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),

          // Email
          Text(
            'hola@zerosignal.app',
            style: TextStyle(
              color: const Color(0xFF565656),
              fontSize: 10.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),

          // Bio
          Text(
            'Outdoor enthusiast & explorer',
            style: TextStyle(
              color: const Color(0xFF2C2C2C),
              fontSize: 10.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),

          // Points
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '1,540 ',
                  style: TextStyle(
                    color: const Color(0xFF2E4F3E),
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: 'Points',
                  style: TextStyle(
                    color: const Color(0xFF2E4F3E),
                    fontSize: 10.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E9DF),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0x23000000),
            blurRadius: 4,
            offset: const Offset(0, 0),
          )
        ],
      ),
      child: Column(
        children: [
          _buildMenuItemWithIcon(
            context,
            iconHeight: 15,
            iconWidth: 15,
            icon: AppIconPath.mySpotsIcon,
            title: 'Favorite Sites',
            onTap: () {
              Get.toNamed(AppRoutes.favoriteSitesScreen);
            },
          ),
          _buildDivider(),
          _buildMenuItemWithIcon(
            context,
            icon: AppIconPath.mySpotsIcon,
            title: 'Favorite Routes',
            onTap: () {
              Get.toNamed(AppRoutes.favoriteSitesScreen);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E9DF),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0x23000000),
            blurRadius: 4,
            offset: const Offset(0, 0),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SETTINGS',
            style: TextStyle(
              color: Color(0xFF2C2C2C),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          _buildDivider(),
          _buildMenuItem('Language'),
          _buildDivider(),
          _buildMenuItem('Change Password'),
          _buildDivider(),
          _buildMenuItem('Delete account', color: const Color(0xFFFB6057)),
          _buildDivider(),
          _buildMenuItem('Manage Download'),
          _buildDivider(),
          GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.conditionsScreen, arguments: 'About Us');
              },
              child: _buildMenuItem('About Us')),
          _buildDivider(),
          GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.conditionsScreen,
                    arguments: 'Privacy Policy');
              },
              child: _buildMenuItem('Privacy Policy')),
          _buildDivider(),
          GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.conditionsScreen,
                    arguments: 'Terms & Conditions');
              },
              child: _buildMenuItem('Terms & Conditions')),
          _buildDivider(),
          GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.conditionsScreen, arguments: 'FAQ');
              },
              child: _buildMenuItem('FAQ')),
          _buildDivider(),
          GestureDetector(
              onTap: () {
                showLogoutDialog(context: context);
              },
              child: _buildMenuItemWithoutArrow('Logout',
                  color: const Color(0xFFFB6057))),
        ],
      ),
    );
  }

  /// MENU ITEM WITH ICON + TITLE
  Widget _buildMenuItemWithIcon(
      BuildContext context, {
        required String icon,
        required String title,
        required VoidCallback onTap,
        Color titleColor = const Color(0xFF2C2C2C),
        double iconWidth = 24,   // Default width
        double iconHeight = 24,  // Default height
      }) {
    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconWidget(
                icon: icon,
                width: iconWidth,
                height: iconHeight,
              ),
              const SpaceWidget(spaceWidth: 12),
              TextWidget(
                text: title,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontColor: titleColor,
              ),
            ],
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
            size: 12,
          ),
        ],
      ),
    );
  }


  /// SIMPLE MENU ITEM (TEXT ONLY)
  Widget _buildMenuItem(String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color ?? const Color(0xFF2C2C2C),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 20,
            color: color ?? const Color(0xFF2C2C2C),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemWithoutArrow(String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          color: color ?? const Color(0xFF2C2C2C),
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 0.5,
      color: const Color(0x99D6C8B0),
    );
  }
}

class LogoutAlertDialog extends StatelessWidget {
  const LogoutAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFFFF4E9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.all(12),
      content: SizedBox(
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, size: 24),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
            const SizedBox(height: 20),
            // Title and message
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Logout',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2C2C2C),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.10,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Are you sure you want to Logout?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF565656),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // No button
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFF2E4F3E),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: const Text(
                        'No',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF2E4F3E),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.10,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Yes button
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF2E4F3E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.offAllNamed(AppRoutes.signInScreen);
                        print('User logged out');
                      },
                      child: const Text(
                        'Yes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFF1F1F1),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Dialog show korar jonno ei function use korben
void showLogoutDialog({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const LogoutAlertDialog();
    },
  );
}
