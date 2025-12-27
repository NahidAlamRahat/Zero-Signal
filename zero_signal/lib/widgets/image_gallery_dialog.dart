import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:typed_data';

class ImageGalleryDialog extends StatefulWidget {
  final List<String> networkImages;
  final Uint8List? mapScreenshot;
  final int initialIndex;

  const ImageGalleryDialog({
    super.key,
    required this.networkImages,
    this.mapScreenshot,
    this.initialIndex = 0,
  });

  @override
  State<ImageGalleryDialog> createState() => _ImageGalleryDialogState();
}

class _ImageGalleryDialogState extends State<ImageGalleryDialog> {
  late int selectedIndex;
  late List<dynamic> allImages;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    
    // Combine map screenshot and network images
    allImages = [];
    if (widget.mapScreenshot != null) {
      allImages.add(widget.mapScreenshot);
    }
    allImages.addAll(widget.networkImages);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4E9),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Text(
                  'Image Gallery',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16.w,
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Main Large Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                width: double.infinity,
                height: 260.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: _buildMainImage(),
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Thumbnail Row
            SizedBox(
              height: 72.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: allImages.length,
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      width: 72.w,
                      height: 72.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected 
                              ? const Color(0xFFFFA726)
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: _buildThumbnail(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainImage() {
    final image = allImages[selectedIndex];
    
    if (image is Uint8List) {
      // Map screenshot
      return Image.memory(
        image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Center(
              child: Icon(
                Icons.map,
                size: 50.w,
                color: Colors.grey[600],
              ),
            ),
          );
        },
      );
    } else {
      // Network image
      return Image.network(
        image as String,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: const Color(0xFF3A5A4D),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Center(
              child: Icon(
                Icons.image_not_supported,
                size: 50.w,
                color: Colors.grey[600],
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildThumbnail(int index) {
    final image = allImages[index];
    
    if (image is Uint8List) {
      // Map screenshot thumbnail
      return Image.memory(
        image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Icon(
              Icons.map,
              size: 20.w,
              color: Colors.grey[600],
            ),
          );
        },
      );
    } else {
      // Network image thumbnail
      return Image.network(
        image as String,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Icon(
              Icons.image_not_supported,
              size: 20.w,
              color: Colors.grey[600],
            ),
          );
        },
      );
    }
  }
}
