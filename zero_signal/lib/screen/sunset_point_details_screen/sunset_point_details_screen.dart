import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/api_end_point.dart';
import 'package:zero_signal/screen/my_spots_screen/model/my_spots_response_model.dart';

import '../../constant/app_colors.dart';
import '../../widget/text_widget/text_widgets.dart';

class SunsetPointDetailsScreen extends StatefulWidget {
  const SunsetPointDetailsScreen({super.key});

  @override
  State<SunsetPointDetailsScreen> createState() =>
      _ListViewDetailsScreenState();
}

class _ListViewDetailsScreenState extends State<SunsetPointDetailsScreen> {
  bool isFavorite = false;
  late SpotData spot;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    spot = Get.arguments as SpotData;
  }

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
                    // Hero Image
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
          Expanded(
            child: TextWidget(
              text: '${spot.title} Details',
              textAlignment: TextAlign.center,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              fontColor: AppColor.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    if (spot.images.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 219.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[300],
        ),
        child: const Icon(Icons.image_not_supported, size: 50),
      );
    }

    return SizedBox(
      height: 219.h,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: spot.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final imageUrl = spot.images[index].startsWith('http')
                  ? spot.images[index]
                  : '${AppApiEndPoint.domain}${spot.images[index]}';

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          if (spot.images.length > 1)
            Positioned(
              bottom: 15.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  spot.images.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? AppColor.backgroundColor
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
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
        SizedBox(
          height: 16.h,
        ),
        TextWidget(
          text: spot.title,
          fontColor: AppColor.textColor,
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(
          height: 4.h,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on,
              size: 16,
              color: Colors.red,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: TextWidget(
                text: spot.address,
                fontColor: AppColor.darkGay300,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                textAlignment: TextAlign.start,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16.h,
        ),
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
        SizedBox(
          height: 16.h,
        ),
        TextWidget(
          textAlignment: TextAlign.start,
          text: spot.description,
          fontColor: AppColor.darkGay300,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
