import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final String icon;
  final Color? color;

  const IconWidget({
    super.key,
     this.height,
     this.width,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      icon,
      height: (height ?? 36).h,
      width: (width ?? 36).w,
      fit: BoxFit.cover,
      color: color,
    );
  }
}
