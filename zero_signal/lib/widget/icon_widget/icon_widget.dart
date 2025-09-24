import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_size.dart';

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
    ResponsiveUtils.initialize(context);
    return Image.asset(
      icon,
      height: ResponsiveUtils.width(height?.h ?? 36),
      width: ResponsiveUtils.width(width?.w ?? 36),
      fit: BoxFit.cover,
      color: color,
    );
  }
}
