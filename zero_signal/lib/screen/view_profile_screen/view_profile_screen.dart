import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';

import '../../constant/app_colors.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        backgroundColor:  AppColor.creamBackgroundColor,

      ),
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


          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: 390,
      height: 212,
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
                  text: "Lam loves to explore new places and experience different cultures. Her heart beats for the thrill of adventure. She finds joy in every journey, whether it's wandering through ancient ruins, hiking up a mountain, or simply getting lost in a new city.",
                  style: TextStyle(
                    color: Color(0xFF2E4F3E),
                    fontSize: 12.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
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