import 'package:flutter/material.dart';

class GlassEffact extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final Widget? child;

  const GlassEffact({
    this.child,
    super.key,
    this.height = 371,
    this.width = 390,
    this.borderRadius = 40,
    this.backgroundColor = const Color.fromRGBO(255, 255, 255, 0.2),
    this.borderColor = const Color.fromRGBO(255, 255, 255, 0.3),
    this.borderWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
           height: height,
          width: width,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
          ),
           child: child,
        ),
      ),
    );
  }
}
