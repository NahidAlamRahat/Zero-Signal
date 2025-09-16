import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_image_path.dart';

class GlassEffectBackground extends StatelessWidget {
  const GlassEffectBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background image
          Positioned.fill(
            child: Image.asset(
              AppImagePath.onboardingBackgroundImage,
              fit: BoxFit.cover,
            ),
          ),

          /// Glassmorphism overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1), // blur strength
              child: Container(
                color: Colors.black.withOpacity(0.2), // glass tint
              ),
            ),
          ),

          /// Your main content
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withOpacity(0.2),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: const Text(
                "Glass Effect Box",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}