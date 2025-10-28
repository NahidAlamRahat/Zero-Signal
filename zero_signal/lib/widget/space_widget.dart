import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpaceWidget extends StatelessWidget {
  final double spaceHeight;
  final double spaceWidth;

  const SpaceWidget({
    super.key,
    this.spaceHeight = 0.0,
    this.spaceWidth = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    if (spaceHeight != 0.0 && spaceWidth != 0.0) {
      return SizedBox(
        height: spaceHeight.h,
        width: spaceWidth.w,
      );
    } else if (spaceHeight != 0.0 && spaceWidth == 0.0) {
      return SizedBox(
        height: spaceHeight.h,
      );
    } else if (spaceHeight == 0.0 && spaceWidth != 0.0) {
      return SizedBox(
        width: spaceWidth.w,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
