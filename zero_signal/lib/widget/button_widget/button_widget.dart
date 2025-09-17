import 'package:flutter/material.dart';
import '../../utils/app_size.dart';

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
  final double opacity; // ✅ নতুন opacity parameter

  const ButtonWidget({
    super.key,
    this.label,
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
    this.opacity = 1.0, // ✅ default opacity 1.0 (fully opaque)
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.initialize(context);

    // ✅ Background color with opacity applied
    Color finalBackgroundColor = (backgroundColor ?? Colors.green.shade500)
        .withOpacity(opacity);

    return Container(
      height: ResponsiveUtils.height(buttonHeight),
      width: ResponsiveUtils.width(buttonWidth),
      decoration: BoxDecoration(
        color: finalBackgroundColor,
        borderRadius: buttonRadius,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1)
            : null,
      ),
      child: MaterialButton(
        onPressed: isLoading ? null : onPressed,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: padding,
        color: Colors.transparent, // ✅ MaterialButton এর background transparent করুন
        elevation: 0, // ✅ Shadow remove করুন
        highlightElevation: 0, // ✅ Press করার সময় shadow remove করুন
        shape: RoundedRectangleBorder(borderRadius: buttonRadius),
        child: isLoading
            ? const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : label != null
            ? Text(
          label!,
          style: TextStyle(
            color: textColor,
            fontSize: ResponsiveUtils.width(fontSize),
            fontWeight: fontWeight ?? FontWeight.w500,
          ),
        )
            : (icon != null
            ? SizedBox(child: icon)
            : const SizedBox()),
      ),
    );
  }
}