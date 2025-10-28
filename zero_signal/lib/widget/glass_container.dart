import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  const GlassContainer({
    super.key,
    this.width = 150,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 3.0,
          sigmaY: 3.0,
        ), // Minimal blur for subtle glass effect
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            // Higher transparency for brighter effect
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(25.0),
            // Brighter border - white on left and top only
            border: Border(
              left: BorderSide(
                color: Colors.white.withValues(alpha: 0.6),
                width: 1.0,
              ),
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.6),
                width: 1.0,
              ),
              right: BorderSide(
                color: Colors.white.withValues(alpha: 0.6),
                width: 0.25,
              ),
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.6),
                width: 0.25,
              ),
            ),
            // Minimal shadow for lighter appearance
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
