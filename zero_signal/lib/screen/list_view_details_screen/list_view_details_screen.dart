import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/api_end_point.dart';
import 'package:zero_signal/screen/list_view_details_screen/widget/location_map_widget.dart';
import '../../constant/app_colors.dart';
import '../../widget/text_widget/text_widgets.dart';
import 'controller/list_view_details_controller.dart';

class ListViewDetailsScreen extends StatefulWidget {
  const ListViewDetailsScreen({super.key});

  @override
  State<ListViewDetailsScreen> createState() => _ListViewDetailsScreenState();
}

class _ListViewDetailsScreenState extends State<ListViewDetailsScreen> {
  final controller = Get.put(ListViewDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E9),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero Image Slider
                    _buildHeroImage(),

                    // Details Section
                    _buildDetailsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 24,
              color: Color(0xFF2C2C2C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    final images = controller.activity.images.isNotEmpty
        ? controller.activity.images
        : [controller.activity.imagePath];

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: 219.h,
          child: Stack(
            children: [
              PageView.builder(
                itemCount: images.length,
                onPageChanged: (index) => controller.updateImageIndex(index),
                itemBuilder: (context, index) {
                  final imageUrl = images[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: (imageUrl.startsWith('http') ||
                            imageUrl.startsWith('/'))
                        ? Image.network(
                            '${AppApiEndPoint.domain}$imageUrl',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Image.asset(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => Container(
                  width: 8.w,
                  height: 8.h,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.currentImageIndex.value == index
                        ? AppColor.backgroundColor
                        : Colors.grey.shade400,
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Location
          _buildTitleSection(),

          // Location Map
          _buildLocationMap(),

          // Description
          _buildDescriptionSection(),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        TextWidget(
          text: controller.activity.title,
          fontColor: AppColor.textColor,
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            const Icon(
              Icons.location_on,
              size: 16,
              color: Colors.red,
            ),
            const SizedBox(width: 4),
            TextWidget(
              text: controller.activity.location,
              fontColor: AppColor.darkGay300,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        SizedBox(height: 4.h),
        TextWidget(
          text: controller.activity.category,
          fontColor: AppColor.darkGay300,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildLocationMap() {
    final activity = controller.activity;
    if (activity.latitude == null || activity.longitude == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: 'Location',
          fontColor: AppColor.textColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 12.h),
        LocationMapWidget(
          latitude: activity.latitude!,
          longitude: activity.longitude!,
          markerTitle: activity.title,
          height: 250,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: 'Description',
          fontColor: AppColor.textColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(height: 16.h),
        TextWidget(
          textAlignment: TextAlign.start,
          text: controller.activity.description ?? 'No description available.',
          fontColor: AppColor.darkGay300,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
