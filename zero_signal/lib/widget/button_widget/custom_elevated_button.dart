import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Size minimumSize;
  final Size? maximumSize;
  final IconData? leftIcon; // The new optional icon on the left
  final IconData? rightIcon; // The original optional icon, now on the right
  final double? iconSize;
  final FontWeight? fontWeight;
  final double fontSize;
  final Color borderColor;
  final MainAxisAlignment alignment;
  final Color? rightIconColor;
  final double borderRadius;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFCDA861),
    this.textColor = Colors.white,
    this.minimumSize = const Size(150, 48),
    this.maximumSize,
    this.leftIcon, // Added this property
    this.rightIcon, // Your original icon, renamed for clarity
    this.fontWeight ,
    this.fontSize = 16,
    this.borderColor = const Color(0xFFB16D2E),
    this.alignment = MainAxisAlignment.center,
    this.rightIconColor,
    this.borderRadius = 8.0,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          maximumSize: maximumSize,
          minimumSize: minimumSize,
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(width: 1, color: borderColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: alignment,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Conditionally show the LEFT icon
            if (leftIcon != null) ...[
              Icon(leftIcon, size: iconSize),
              SizedBox(width: 8.w),
            ],

            // The main text
            TextWidget(
            text:   text,
              // style: TextStyle(fontSize: fontSize.sp, fontWeight: fontWeight),
              fontSize: fontSize,
              fontWeight: fontWeight ?? FontWeight.w500,
              fontColor: textColor,
            ),

            // Conditionally show the RIGHT icon
            if (rightIcon != null) ...[
              SizedBox(width: 8.w),
              Icon(rightIcon, size: iconSize, color: rightIconColor),
            ],
          ],
        ),
      ),
    );
  }
}
