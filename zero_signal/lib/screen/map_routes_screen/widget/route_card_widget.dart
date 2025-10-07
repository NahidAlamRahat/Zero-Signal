import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/utils/app_size.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';
import '../../../constant/app_colors.dart';

class RouteCard extends StatelessWidget {
  const RouteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.creamBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage(AppImagePath.routeImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Route Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Portbou - Colera',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFCB20),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Image.asset(
                          AppIconPath.saveIcon,
                          width: 18,
                          height: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Tags Row 1
                Row(
                  children: [
                    _buildTag(
                      text: '6.5 Km',
                      backgroundColor: Colors.blue.shade50,
                      textColor: Colors.blue.shade600,
                      borderColor: const Color(0xFF5080FF),
                    ),
                    const SizedBox(width: 8),
                    _buildTag(
                      text: 'Medium',
                      backgroundColor: Colors.green.shade50,
                      textColor: Colors.green.shade600,
                      borderColor: const Color(0xFF399060),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Tags Row 2
                Row(
                  children: [
                    _buildTag(
                      text: '1h 20m',
                      backgroundColor: Colors.purple.shade50,
                      textColor: Colors.purple.shade600,
                      borderColor: const Color(0xFFAA5BF2),
                    ),
                    const SizedBox(width: 8),
                    _buildTag(
                      text: '+240 m',
                      backgroundColor: Colors.orange.shade50,
                      textColor: Colors.orange.shade600,
                      borderColor: const Color(0xFFDE800C),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Center(
        child: TextWidget(
          text: text,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontColor: textColor,
        ),
      ),
    );
  }
}