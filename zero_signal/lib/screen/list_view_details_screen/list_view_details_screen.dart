import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/screen/list_view_details_screen/widget/location_map_widget.dart';

import '../../constant/app_colors.dart';
import '../../widget/text_widget/text_widgets.dart';

class ListViewDetailsScreen extends StatefulWidget {
  const ListViewDetailsScreen({super.key});

  @override
  State<ListViewDetailsScreen> createState() => _ListViewDetailsScreenState();
}

class _ListViewDetailsScreenState extends State<ListViewDetailsScreen> {
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

  Widget _buildLocationMap() {
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
          latitude: 42.3601,
          longitude: -71.0589,
          markerTitle: 'Sunset Point',
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