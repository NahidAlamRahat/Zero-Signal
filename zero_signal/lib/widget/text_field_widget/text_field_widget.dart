import 'package:flutter/material.dart';
import '../../utils/app_size.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool? suffixIcon; // For password toggle
  final TextInputType? keyboardType;
  final int maxLines;
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
  final TextStyle? hintStyle; // <-- বাহির থেকে hintStyle কাস্টমাইজ করা যাবে
  final TextStyle? textStyle; // <-- বাহির থেকে textStyle কাস্টমাইজ করা যাবে
  final TextStyle? errorStyle; // <-- বাহির থেকে errorStyle কাস্টমাইজ করা যাবে

  const TextFieldWidget({
    super.key,
    this.controller,
    this.hintText,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.maxLines = 1,
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
    this.hintStyle,
    this.textStyle,
    this.errorStyle,
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
    ResponsiveUtils.initialize(context);
    return Container(
      height: widget.fieldHeight,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: TextFormField(
        onFieldSubmitted: widget.onFieldSubmitted,
        controller: widget.controller,
        validator: widget.validator,
        obscureText: obscureText,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        style: widget.textStyle ??
            TextStyle(
              color: widget.textColor,
              fontSize: ResponsiveUtils.width(14), // default font size
            ),
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.backgroundColor,
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ??
              TextStyle(
                color: widget.hintColor,
                fontWeight: FontWeight.w400,
                fontSize: ResponsiveUtils.width(14),
              ),
          errorStyle: widget.errorStyle ??
              TextStyle(
                color: Colors.red,
                fontSize: ResponsiveUtils.width(12),
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
              padding: const EdgeInsets.all(13),
              child: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade400,
              ),
            ),
          )
              : widget.customSuffixIcon,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: (widget.fieldHeight - 20) / 2,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: widget.focusedBorderColor,
              width: widget.borderWidth,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: Colors.red,
              width: widget.borderWidth,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: Colors.red,
              width: widget.borderWidth,
            ),
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
