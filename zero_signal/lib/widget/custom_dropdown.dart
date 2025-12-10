import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedValue;
  final String hint;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Color? dropdownColor; // Menu background color
  final Color? boxColor;
  final Color borderColor;
  final double borderRadius;
  const CustomDropdown({
    super.key,
    this.dropdownColor,
    this.boxColor,
    required this.items,
    this.selectedValue,
    required this.hint,
    this.onChanged,
    this.validator,
    this.borderColor = const Color(0xFF181818),
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      icon: Icon(
          color: Color(


              0xFF484949),

          size: 28.sp,
          Icons.keyboard_arrow_down),
      value: selectedValue,
      isExpanded: true,
      decoration: InputDecoration(
        filled: true, // ✅ এটা অবশ্যই দিতে হবে
        fillColor: boxColor ?? Colors.white, // ✅ Default white, বাহির থেকে change করা যাবে
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      hint: Text(
        hint,
        style: const TextStyle(color: Colors.grey),
      ),
      items: items.map((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      dropdownColor: dropdownColor ?? Colors.white,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
