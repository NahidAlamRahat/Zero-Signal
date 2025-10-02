import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../constant/app_strings.dart';
import '../../routes/app_routes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundImage(),
          _buildTitleText(),
          _buildGetStartedButton(context),
        ],
      ),
    );
  }

  /// Background image widget
  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        AppImagePath.onboardingBackgroundImage,
        fit: BoxFit.cover,
      ),
    );
  }

  /// Title text widget
  Widget _buildTitleText() {
    return  Positioned(
      bottom: 140,
      left: 0,
      right: 0,
      child: TextWidget(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        textAlignment: TextAlign.center,
        text: AppStrings.discoverNewWorld,
        fontColor: Colors.white,
      ),
    );
  }

  /// Get Started button widget
  Widget _buildGetStartedButton(BuildContext context) {
    return Positioned(
      bottom: kBottomNavigationBarHeight,
      left: 16,
      right: 16,
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.signInAndRegistrationScreen);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF2E4F3E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              // Centered text
              const Center(
                child: Text(
                  AppStrings.getStarted,
                  style: TextStyle(
                    color: Color(0xFFF1F1F1),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.10,
                  ),
                ),
              ),
              // Right-aligned icon
              Positioned(
                right: 16,
                top: 10,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA726),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}