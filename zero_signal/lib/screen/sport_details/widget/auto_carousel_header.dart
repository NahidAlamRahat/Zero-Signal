import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/api_end_point.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/screen/sport_details/controller/sport_details_controller.dart';

class AutoCarouselHeader extends StatefulWidget {
  const AutoCarouselHeader({super.key});

  @override
  State<AutoCarouselHeader> createState() => _AutoCarouselHeaderState();
}

class _AutoCarouselHeaderState extends State<AutoCarouselHeader>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  int _currentPage = 0;
  final SportDetailsController controller = Get.find<SportDetailsController>();

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          int imageCount =
              controller.images.isNotEmpty ? controller.images.length : 1;
          if (_currentPage < imageCount - 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }
        });
      }
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
              child: Obx(() {
                if (controller.images.isEmpty) {
                  // Fallback to static placeholder if no images
                  return Image.asset(
                    AppImagePath.viewImage,
                    width: double.infinity,
                    height: 219.h,
                    fit: BoxFit.cover,
                  );
                }

                // Ensure current page is valid
                if (_currentPage >= controller.images.length) {
                  _currentPage = 0;
                }

                final imagePath = controller.images[_currentPage];
                final fullImageUrl = imagePath.startsWith('http')
                    ? imagePath
                    : '${AppApiEndPoint.domain}$imagePath';

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
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
                  child: Image.network(
                    fullImageUrl,
                    key: ValueKey<String>(fullImageUrl),
                    width: double.infinity,
                    height: 219.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AppImagePath.viewImage, // Fallback on error
                        width: double.infinity,
                        height: 219.h,
                        fit: BoxFit.cover,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
            // Page Indicator
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Obx(() {
                if (controller.images.isEmpty) return const SizedBox.shrink();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.images.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage == index
                            ? AppColor.white500
                            : AppColor.white500.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
