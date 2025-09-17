import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/screen/sign_in_screen/widget/glass_effact.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundImage(),
          GlassEffact(),
          
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





}