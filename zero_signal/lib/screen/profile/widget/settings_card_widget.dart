import 'package:flutter/material.dart';
import 'package:zero_signal/gen/assets.gen.dart';
import 'package:zero_signal/routes/app_routes.dart';
import '../../../widget/space_widget.dart';
import '../controller/profile_controller.dart';
import 'delete_account_alert_dialog.dart';
import 'logout_alert_dialog.dart';
import 'menuItem_widget.dart';


class SettingsCardWidget extends StatelessWidget {
  final ProfileController controller;

  const SettingsCardWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
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
          SpaceWidget(spaceHeight: 12),
          _buildDivider(),
          SpaceWidget(spaceHeight: 16),
          MenuItemWidget(
            icon: Assets.icons.languageImage.path,
            title: 'Language',
            onTap: () => controller.navigateToRoute(AppRoutes.changeLanguageScreen),
          ),
          _buildDivider(),
          MenuItemWidget(
            icon: Assets.icons.changePasswordImage.path,
            title: 'Change Password',
            onTap: () => controller.navigateToRoute(AppRoutes.changePasswordScreen),
          ),
          _buildDivider(),
          MenuItemWidget(
            icon: Assets.icons.deleteIcon.path,
            title: 'Delete account',
            titleColor: const Color(0xFFFB6057),
            onTap: () => showDeleteAccountDialog(context: context, controller: controller, ),

          ),
          _buildDivider(),
          MenuItemWidget(
            icon: Assets.icons.manageDownloadImage.path,
            title: 'Manage Download',
            onTap: () => controller.navigateToRoute(AppRoutes.manageDownloadScreen),
          ),
          _buildDivider(),
          MenuItemWidget(
            icon: Assets.icons.aboutUsImage.path,
            title: 'About Us',
            onTap: () => controller.navigateToRoute(AppRoutes.conditionsScreen, arguments: 'About Us'),
          ),
          _buildDivider(),
          MenuItemWidget(
            icon: Assets.icons.privacyPolicyImage.path,
            title: 'Privacy Policy',
            onTap: () => controller.navigateToRoute(AppRoutes.conditionsScreen, arguments: 'Privacy Policy'),
          ),
          _buildDivider(),
          MenuItemWidget(
            icon: Assets.icons.termsAndConditionsImage.path,
            title: 'Terms & Conditions',
            onTap: () => controller.navigateToRoute(AppRoutes.conditionsScreen, arguments: 'Terms & Conditions'),
          ),
          _buildDivider(),
          MenuItemWidget(
            icon: Assets.icons.termsAndConditionsImage.path,
            title: 'FAQ',
            onTap: () => controller.navigateToRoute(AppRoutes.conditionsScreen, arguments: 'FAQ'),
          ),
          _buildDivider(),
          MenuItemWidget(
            icon: Assets.icons.logoutImage.path,
            title: 'Logout',
            onTap: () => showLogoutDialog(context: context, controller: controller),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Column(
      children: [
        SpaceWidget(spaceHeight: 16),
        Container(
          height: 0.5,
          color: const Color(0x99D6C8B0),
        ),
        SpaceWidget(spaceHeight: 16),
      ],
    );
  }
}
