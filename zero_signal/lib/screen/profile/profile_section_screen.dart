import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_image_path.dart';

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
            _buildMenuItemsCard(),

            // Settings Card
            _buildSettingsCard(),
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
          Container(
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

          // Name
           Text(
            'Liam Johnson',
            style: TextStyle(
              color: Color(0xFF2C2C2C),
              fontSize: 12.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),

          // Email
           Text(
            'hola@zerosignal.app',
            style: TextStyle(
              color: Color(0xFF565656),
              fontSize: 10.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),

          // Bio
           Text(
            'Outdoor enthusiast & explorer',
            style: TextStyle(
              color: Color(0xFF2C2C2C),
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
                    color: Color(0xFF2E4F3E),
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                 TextSpan(
                  text: 'Points',
                  style: TextStyle(
                    color: Color(0xFF2E4F3E),
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

  Widget _buildMenuItemsCard() {
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
          _buildMenuItem('My Spots'),
          _buildDivider(),
          _buildMenuItem('My Routes'),
          _buildDivider(),
          _buildMenuItem('Favorite Sites'),
          _buildDivider(),
          _buildMenuItem('Favorite Routes'),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
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
          _buildMenuItem('About Us'),
          _buildDivider(),
          _buildMenuItem('Privacy Policy'),
          _buildDivider(),
          _buildMenuItem('Terms & Conditions'),
          _buildDivider(),
          _buildMenuItem('FAQ'),
          _buildDivider(),
          _buildMenuItemWithoutArrow('Logout', color: const Color(0xFFFB6057)),
        ],
      ),
    );
  }

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