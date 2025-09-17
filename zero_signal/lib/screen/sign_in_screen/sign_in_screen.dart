import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_image_path.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        AppImagePath.signInBackgroundImage,
        fit: BoxFit.cover,
      ),
    );
  }


  Widget _buildTitleText() {
    return  Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Image.asset(AppImagePath.frameImage),
    );
  }


  /// Get Started button widget
  Widget _buildGetStartedButton(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 16,
      right: 16,
      child: InkWell(
        onTap: () {
          // Add your navigation logic here
          // Navigator.pushNamed(context, '/next_screen');
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
                  'Get Started',
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
                    color: Colors.black87,
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