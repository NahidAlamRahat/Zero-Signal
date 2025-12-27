import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/screen/sport_details/controller/sport_details_controller.dart';

class ImageGalleryDialog extends StatelessWidget {
  final SportDetailsController controller;
  const ImageGalleryDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(24),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.creamBackgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main Image Display
            Obx(() => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: controller.selectedImage.value.isNotEmpty
                  ? Image.asset(
                controller.selectedImage.value,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: Icon(Icons.error,
                          size: 64, color: Colors.grey[600]),
                    ),
              )
                  : Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.image,
                    size: 64, color: Colors.red),
              ),
            )),
            SizedBox(height: 16),
            // Thumbnails List
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemCount: controller.images.length,
                separatorBuilder: (context, index) => SizedBox(width: 10),
                itemBuilder: (context, imgIndex) {
                  final imgPath = controller.images[imgIndex];
                  return Obx(() {
                    final isSelected =
                        controller.selectedImage.value == imgPath;
                    return GestureDetector(
                      onTap: () => controller.selectImage(imgPath),
                      child: Container(
                        width: 90,
                        height: 110,
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: isSelected
                                  ? Colors.amber
                                  : Colors.transparent,
                              width: 3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            imgPath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
