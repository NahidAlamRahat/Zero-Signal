import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_image_path.dart';

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
        children: [
          // Route Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage(AppImagePath.routeImage,),
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
                // Title
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(
                      'Portbou - Colera',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                     ),
                     Container(
                       width: 30.w,
                       height: 30.h,
                       padding: const EdgeInsets.all(2),
                       decoration: BoxDecoration(
                         color: Colors.yellow.shade400,
                         shape: BoxShape.circle,
                       ),
                       child: Icon(
                         Icons.bookmark_border,
                         color: Colors.white,
                         size: 18,
                       ),
                     ),


                   ],
                 ),
                const SizedBox(height: 12),

                // Tags Row 1
                Row(
                  children: [
                    _buildTag(text:  '6.5 Km', backgroundColor: Colors.blue.shade50, textColor:  Colors.blue.shade600,borderColor: Color(0xFF5080FF)),
                    const SizedBox(width: 8),
                    _buildTag(text:  'Medium', backgroundColor:  Colors.green.shade50, textColor: Colors.green.shade600,borderColor: Color(0xFF399060)),
                  ],
                ),
                const SizedBox(height: 8),

                // Tags Row 2
                Row(
                  children: [
                    _buildTag(text: '1h 20m', backgroundColor: Colors.purple.shade50, textColor:  Colors.purple.shade600,borderColor: Color(0xFFAA5BF2)),
                    const SizedBox(width: 8),
                    _buildTag(text: '+240 m', backgroundColor: Colors.orange.shade50, textColor: Colors.orange.shade600,borderColor: Color(0xFFDE800C)),
                  ],
                ),
              ],
            ),
          ),

          // Bookmark Icon

        ],
      ),
    );
  }

  Widget _buildTag(
      {String? text, Color? backgroundColor, Color? textColor, Color? borderColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor ?? Colors.transparent),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text?? '',
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
