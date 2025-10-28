import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../widget/button_widget/button_widget.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String selectedActivity = 'Walking';
  String selectedDifficulty = 'Easy';
  double distanceValue = 125.0; // Default value for 0m to +250km
  String selectedRouteType = 'Round trip';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.creamBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.creamBackgroundColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filters',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Activity Selection GridView
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 118 / 90, // width/height ratio for maintaining card proportions
                children: [
                  _buildActivityCard('Walking', Assets.icons.walking.path, 'Walking'),
                  _buildActivityCard('Hiking', Assets.icons.hiking.path, 'Hiking'),
                  _buildActivityCard('Running', Assets.icons.running.path, 'Running'),
                  _buildActivityCard('Gravel', Assets.icons.gravel.path, 'Gravel'),
                  _buildActivityCard('Motorcycle', Assets.icons.bike.path, 'Motorcycle'),
                  _buildActivityCard('SUV / 4*4', Assets.icons.car.path, 'SUV / 4*4'),
                  _buildActivityCard('Road Trip', Assets.icons.roadTrip.path, 'Road Trip'),
                ],
              ),

              // Difficulty Section
              const Text(
                'Difficulty',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildDifficultyChip('Easy'),
                    const SizedBox(width: 12),
                    _buildDifficultyChip('Medium'),
                    const SizedBox(width: 12),
                    _buildDifficultyChip('Hard'),
                    const SizedBox(width: 12),
                    _buildDifficultyChip('Extreme'),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // Distance Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Distance:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '0m to +250km',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF2E5233),
                  inactiveTrackColor: Colors.grey[300],
                  thumbColor: const Color(0xFF2E5233),
                  overlayColor: const Color(0xFF2E5233).withOpacity(0.2),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: distanceValue,
                  min: 0,
                  max: 250,
                  onChanged: (value) {
                    setState(() {
                      distanceValue = value;
                    });
                  },
                ),
              ),


              // Type of route Section
              const Text(
                'Type of route',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildRouteTypeChip('Circular'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildRouteTypeChip('Round trip'),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // Apply Filters Button
              Center(
                child: ButtonWidget(
                  backgroundColor: AppColor.backgroundColor,
                  label: 'Apply Filters',
                  buttonWidth: double.infinity,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(
      String title,
      String imageIcon,
      String value) {
    final isSelected = selectedActivity == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedActivity = value;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColor.soilColor : AppColor.lightGrayishOrange,
          borderRadius: BorderRadius.circular(12.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageIcon,
              height: 40.h,
              width: 40.w,
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12.w,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? const Color(0xFF2C2C2C) : const Color(0xFF565656),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(String difficulty) {
    final isSelected = selectedDifficulty == difficulty;
    return GestureDetector(
      // onTap: () {
      //   setState(() {
      //     selectedDifficulty = difficulty;
      //   });
      // },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.soilColor : Color(0xFFF5E9DF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          difficulty,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildRouteTypeChip(String routeType) {
    final isSelected = selectedRouteType == routeType;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRouteType = routeType;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.soilColor : AppColor.lightGrayishOrange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          routeType,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}