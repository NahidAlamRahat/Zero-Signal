import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';
import '../../../constant/app_colors.dart';

class RouteCard extends StatelessWidget {
  final Map<String, dynamic> routeData;
  final VoidCallback? onSave;
  final VoidCallback? onTap;
  final VoidCallback? onPlace;

  const RouteCard({
    super.key,
    required this.routeData,
    this.onSave,
    this.onTap,
    this.onPlace,
  });

  @override
  Widget build(BuildContext context) {
    final title = routeData['title'] ?? 'Unknown Route';
    final distance = routeData['distance']?['text'] ?? '0 km';
    final duration = routeData['duration']?['text'] ?? '0 min';
    final type = routeData['type'] ?? 'Unknown';
    final difficulty = routeData['difficulty'] ?? 'Unknown';
    final description = routeData['description'] ?? '';
    final images = routeData['images'] as List<dynamic>? ?? [];
    final userName = routeData['user']?['name'] ?? 'Unknown User';
    
    // Build image URL
    String imageUrl = '';
    if (images.isNotEmpty) {
      imageUrl = images[0].startsWith('/') 
          ? 'https://shariful5000.binarybards.online${images[0]}'
          : images[0];
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.creamBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
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
                image: DecorationImage(
                  image: imageUrl.isNotEmpty 
                      ? NetworkImage(imageUrl)
                      : const AssetImage(AppImagePath.routeImage),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) {
                    // Fallback to asset image if network image fails
                  },
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (description.isNotEmpty)
                              Text(
                                description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            const SizedBox(height: 4),
                            Text(
                              'by $userName',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: onSave,
                            child: Container(
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
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: onPlace,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.place,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Tags Row 1 - Distance, Type, Difficulty
                  Row(
                    children: [
                      _buildTag(
                        text: distance,
                        backgroundColor: Colors.blue.shade50,
                        textColor: Colors.blue.shade600,
                        borderColor: const Color(0xFF5080FF),
                      ),
                      const SizedBox(width: 8),
                      _buildTag(
                        text: type,
                        backgroundColor: Colors.green.shade50,
                        textColor: Colors.green.shade600,
                        borderColor: const Color(0xFF399060),
                      ),
                      const SizedBox(width: 8),
                      _buildTag(
                        text: difficulty,
                        backgroundColor: Colors.orange.shade50,
                        textColor: Colors.orange.shade600,
                        borderColor: const Color(0xFFDE800C),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Tags Row 2 - Duration
                  Row(
                    children: [
                      _buildTag(
                        text: duration,
                        backgroundColor: Colors.purple.shade50,
                        textColor: Colors.purple.shade600,
                        borderColor: const Color(0xFFAA5BF2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextWidget(
        text: text,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontColor: textColor,
      ),
    );
  }
}
