import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_image_path.dart';

import '../../constant/app_colors.dart';
import '../../widget/text_widget/text_widgets.dart';

class SunsetPointDetailsScreen extends StatefulWidget {
  const SunsetPointDetailsScreen({super.key});

  @override
  State<SunsetPointDetailsScreen> createState() => _ListViewDetailsScreenState();
}

class _ListViewDetailsScreenState extends State<SunsetPointDetailsScreen> {
  bool isFavorite = false;

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
              text:  'Sunset Point Details',
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 219,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(AppImagePath.sunImage),
          fit: BoxFit.cover,
        ),
      ),

    );
  }

  Widget _buildDetailsSection() {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 20.w),
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
        SizedBox(height: 16.h,),
        TextWidget(
          text: 'Sunset Point',
          fontColor: AppColor.textColor,
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 4.h,),
        Row(
          children: [
            const Icon(
              Icons.location_on,
              size: 16,
              color: Colors.red,
            ),
            const SizedBox(width: 4),
            TextWidget(
              text: 'Espot, Catalonia',
              fontColor: AppColor.darkGay300,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        SizedBox(height: 4.h,),
        TextWidget(
          text: 'Near Olot, Catalonia',
          fontColor: AppColor.darkGay300,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(height: 16.h,),
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
        SizedBox(height: 16.h,),
        TextWidget(
          textAlignment: TextAlign.start,
          text: 'Escape the heat at the Azure Oasis. This stunning, crystal-clear pool is a tranquil paradise, surrounded by lush greenery. It\'s the perfect spot to relax, refresh, and immerse yourself in serene beauty.',
          fontColor: AppColor.darkGay300,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }







}