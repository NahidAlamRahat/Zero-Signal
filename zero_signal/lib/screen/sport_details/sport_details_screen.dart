import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/screen/sport_details/controller/sport_details_controller.dart';
import 'package:zero_signal/screen/sport_details/widget/auto_carousel_header.dart';
import 'package:zero_signal/screen/sport_details/widget/comment_widgets.dart';
import 'package:zero_signal/screen/sport_details/widget/stats_and_actions.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

class SpotDetailsScreen extends StatelessWidget {
  const SpotDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SportDetailsController());

    return Scaffold(
      appBar: AppbarWidget(
        text: 'Sport Details',
        backgroundColor: AppColor.creamBackgroundColor,
        centerTitle: true,
        action: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Icon(Icons.ios_share),
        ),
      ),
      backgroundColor: AppColor.creamBackgroundColor,
      body: Column(
        children: [
          AutoCarouselHeader(),
          SizedBox(height: 12.h),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'Lakeside Campsite',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    fontColor: AppColor.textColor,
                  ),
                  SizedBox(height: 4.h),

                  Row(
                    children: const [
                      Icon(Icons.location_on, color: Colors.red, size: 16),
                      SizedBox(width: 4),
                      TextWidget(
                        text: 'Espat, Catalonia',
                        fontColor: AppColor.darkGay300,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  StatsSection(),
                  SizedBox(height: 16.h),

                  ActionButtons(),
                  SizedBox(height: 12.h),

                  // Visitor info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.lightGrayishOrange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextWidget(
                      text: '5 user will visit this place on Sunday',
                      fontColor: AppColor.textColor,
                      fontSize: 14,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  _buildDescriptionSection(),
                  SizedBox(height: 16.h),

                  CommentsSection(controller: controller),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Description Section
  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: 'Description',
          fontColor: AppColor.textColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          textAlignment: TextAlign.left,
        ),
        SizedBox(height: 8.h),
        TextWidget(
          text:
              'Escape the heat at the Azure Oasis. This stunning, crystal-clear pool is a tranquil paradise, surrounded by lush greenery. Its the perfect spot to relax, refresh, and immerse yourself in serene beauty.',
          fontColor: AppColor.darkGay300,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          textAlignment: TextAlign.left,
        ),
      ],
    );
  }
}
