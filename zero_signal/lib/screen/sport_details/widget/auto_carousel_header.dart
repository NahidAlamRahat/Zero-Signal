import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';

class AutoCarouselHeader extends StatefulWidget {
  const AutoCarouselHeader({super.key});

  @override
  State<AutoCarouselHeader> createState() => _AutoCarouselHeaderState();
}

class _AutoCarouselHeaderState extends State<AutoCarouselHeader> with SingleTickerProviderStateMixin {
  late Timer _timer;
  int _currentPage = 0;

  // List of images for the carousel
  final List<String> _images = [
    AppImagePath.viewImage,
    AppImagePath.sunImage,
    AppImagePath.image1,
    AppImagePath.image2,
    // Add more image paths here
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        if (_currentPage < _images.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
          right: 20.w,
          left: 20.w,
        ),
        width: double.infinity,
        height: 219.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final scaleAnimation = Tween<double>(
                    begin: 0.8,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutBack,
                  ));
                  
                  return ScaleTransition(
                    scale: scaleAnimation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  _images[_currentPage],
                  key: ValueKey<int>(_currentPage),
                  width: double.infinity,
                  height: 219.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 50),
                      ),
                    );
                  },
                ),
              ),
            ),
             // Page Indicator
            // Positioned(
            //   bottom: 12,
            //   left: 0,
            //   right: 0,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: List.generate(
            //       _images.length,
            //       (index) => AnimatedContainer(
            //         duration: const Duration(milliseconds: 300),
            //         margin: const EdgeInsets.symmetric(horizontal: 4),
            //         width: _currentPage == index ? 24 : 8,
            //         height: 8,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(4),
            //           color: _currentPage == index
            //               ? AppColor.white500
            //               : AppColor.white500.withOpacity(0.4),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
