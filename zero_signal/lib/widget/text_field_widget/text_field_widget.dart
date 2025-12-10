import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_colors.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool? suffixIcon; // For password toggle
  final TextInputType? keyboardType;
  final int maxLines;
  final int? minLines;
  final VoidCallback? onTapSuffix;
  final Function(String submit)? onFieldSubmitted;

  final Color borderColor; // Normal border
  final Color focusedBorderColor; // Focused border
  final double borderRadius; // Rounded corner
  final double borderWidth; // Border thickness

  final Widget? prefixIcon; // Left icon
  final Widget? customSuffixIcon; // Right icon (custom, not password toggle)

  final Color backgroundColor;
  final Color hintColor; // Hint text color
  final Color textColor;

  final double fieldHeight;
  final double? fontSize; // Text font size
  final double? hintFontSize; // Hint font size
  final double? errorFontSize; // Error font size
  final double? horizontalPadding; // Content horizontal padding
  final double? verticalPadding; // Content vertical padding
  final double? iconPadding; // Suffix icon padding

  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final TextStyle? errorStyle;
  final FontWeight? fontWeight;
  final Color? suffixIconColor;
  final List<TextInputFormatter>? inputFormatters;

  const TextFieldWidget({
    super.key,
    this.suffixIconColor,
    this.controller,
    this.hintText,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.minLines = 1,
    this.maxLines = 5,
    this.onTapSuffix,
    this.onFieldSubmitted,
    this.borderColor = const Color(0xFF181818),
    this.focusedBorderColor = const Color(0xFF181818),
    this.borderRadius = 30,
    this.borderWidth = 1,
    this.prefixIcon,
    this.customSuffixIcon,
    this.backgroundColor = Colors.white,
    this.hintColor = Colors.grey,
    this.textColor = const Color(0xFF1A1A1A),
    this.fieldHeight = 50,
    this.fontSize = 14,
    this.hintFontSize = 14,
    this.errorFontSize = 12,
    this.horizontalPadding = 16,
    this.verticalPadding,
    this.iconPadding = 0,
    this.hintStyle,
    this.textStyle,
    this.errorStyle,
    this.fontWeight,
    this.inputFormatters,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.suffixIcon ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.maxLines == 1 ? widget.fieldHeight.h : null,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
      ),
      child: TextFormField(
        onFieldSubmitted: widget.onFieldSubmitted,
        controller: widget.controller,
        validator: widget.validator,
        obscureText: obscureText,
        keyboardType: widget.keyboardType,
        maxLines: obscureText ? 1 : widget.maxLines,
        minLines: obscureText ? 1 : widget.minLines,
        inputFormatters: widget.inputFormatters,
        style: widget.textStyle ??
            TextStyle(
              color: widget.textColor,
              fontSize: widget.fontSize!.sp,
            ),
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.backgroundColor,
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ??
              TextStyle(
                color: widget.hintColor,
                fontWeight: widget.fontWeight ?? FontWeight.w400,
                fontSize: widget.hintFontSize!.sp,
              ),
          errorStyle: widget.errorStyle ??
              TextStyle(
                color: Colors.red,
                fontSize: widget.errorFontSize!.sp,
                fontWeight: FontWeight.w400,
              ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon ?? false
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 0.w),
                    child: Icon(
                      obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: widget.suffixIconColor ?? AppColor.white500,
                      size: 20.sp,
                    ),
                  ),
                )
              : widget.customSuffixIcon != null
                  ? UnconstrainedBox(
                      child: Padding(
                        padding: EdgeInsets.only(right: 0.w),
                        child: widget.customSuffixIcon,
                      ),
                    )
                  : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding!.w,
            vertical:
                widget.verticalPadding?.h ?? ((widget.fieldHeight - 20) / 2).h,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
            borderSide: BorderSide(
              color: widget.borderColor,
              width: widget.borderWidth.w,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
            borderSide: BorderSide(
              color: widget.focusedBorderColor,
              width: widget.borderWidth.w,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
            borderSide: BorderSide(
              color: Colors.red,
              width: widget.borderWidth.w,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
            borderSide: BorderSide(
              color: Colors.red,
              width: widget.borderWidth.w,
            ),
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
