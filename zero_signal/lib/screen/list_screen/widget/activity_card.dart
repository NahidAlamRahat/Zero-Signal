import 'package:flutter/material.dart';
import '../../../constant/app_colors.dart';
import '../list_screen.dart';

class ActivityCard extends StatelessWidget {
  final ActivityItem activity;
  final List<Widget>? buttons;
  final Axis buttonsDirection; // Row or Column
  final Alignment buttonsAlignment; // Left or Right

  const ActivityCard({
    Key? key,
    required this.activity,
    this.buttons,
    this.buttonsDirection = Axis.horizontal, // Default: horizontal
    this.buttonsAlignment = Alignment.centerRight, // Default: Right
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColor.lightGrayishOrange,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Activity Image
            Container(
              width: 116,
              height: 116,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(activity.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // ✅ Activity Details + Buttons
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        activity.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    activity.location,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ✅ Buttons section (can be left or right)
                  if (buttons != null && buttons!.isNotEmpty)
                    Align(
                      alignment: buttonsAlignment, // 🔥 user control
                      child: buttonsDirection == Axis.horizontal
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: buttons!
                            .map((btn) => Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: btn,
                        ))
                            .toList(),
                      )
                          : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: buttonsAlignment == Alignment.centerRight
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: buttons!
                            .map((btn) => Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: btn,
                        ))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
