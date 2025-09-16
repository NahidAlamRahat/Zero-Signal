import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zero_signal/utils/app_size.dart';
import '../../constant/app_colors.dart';
import '../../constant/app_image_path.dart';
import 'controller/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize controller once here
    Get.put(SplashController());

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Scale animation (zoom in effect)
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // Fade animation (opacity)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (controller) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: AppColor.backgroundColor,
            body: Center(
              /// app logo with animation
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Image.asset(
                    AppImagePath.appLogo,
                    height: AppSize.height(value: 166),
                    width: AppSize.width(value: 171),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}



