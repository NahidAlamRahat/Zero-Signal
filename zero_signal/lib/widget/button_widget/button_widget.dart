import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonWidget extends StatelessWidget {
  final String? label;
  final Widget? icon;
  final double? iconHeight;
  final double? iconWidth;
  final Color textColor;
  final double fontSize;
  final VoidCallback? onPressed;
  final double buttonHeight;
  final double buttonWidth;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry buttonRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final FontWeight? fontWeight;
  final bool isLoading;
  final double opacity;
  final double borderWidth;
  final double iconSpacing; // <-- new spacing between text & icon
  final bool iconOnRight;   // <-- option to put icon on right or left
  final int maxLines;

  const ButtonWidget({
    super.key,
    this.label,
    this.maxLines = 1,
    this.icon,
    this.iconHeight,
    this.iconWidth,
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.onPressed,
    this.buttonHeight = 52,
    this.buttonWidth = 339,
    this.padding,
    this.buttonRadius = const BorderRadius.all(Radius.circular(8)),
    this.backgroundColor,
    this.borderColor,
    this.fontWeight,
    this.isLoading = false,
    this.opacity = 1.0,
    this.borderWidth = 0.1,
    this.iconSpacing = 6.0,
    this.iconOnRight = false,
  });

  @override
  Widget build(BuildContext context) {
    Color? finalBackgroundColor =
    (backgroundColor == Colors.transparent)
        ? null
        : (backgroundColor ?? Colors.green.shade500).withOpacity(opacity);

    return Container(
      height: buttonHeight.h,
      width: buttonWidth.w,
      decoration: BoxDecoration(
        color: finalBackgroundColor,
        borderRadius: buttonRadius,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
      ),
      child: MaterialButton(
        onPressed: isLoading ? null : onPressed,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: padding,
        color: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: buttonRadius,
          side: borderColor != null
              ? BorderSide(color: borderColor!, width: 1)
              : BorderSide.none,
        ),
        child: isLoading
            ? const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : (label != null && icon != null)
            ? Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: iconOnRight
              ? [
            Text(
              label!,
              maxLines: maxLines,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize.sp,
                fontWeight: fontWeight ?? FontWeight.w500,
              ),
            ),
            SizedBox(width: iconSpacing.w),
            icon!,
          ]
              : [
            icon!,
            SizedBox(width: iconSpacing.w),
            Text(
              label!,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize.sp,
                fontWeight: fontWeight ?? FontWeight.w500,
              ),
            ),
          ],
        )
            : (label != null)
            ? Text(
          label!,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize.sp,
            fontWeight: fontWeight ?? FontWeight.w500,
          ),
        )
            : (icon ?? const SizedBox()),
      ),
    );
  }
}
