import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';
import '../../widget/button_widget/button_widget.dart';
import '../../constant/api_end_point.dart';
import 'controller/filters_controller.dart';

class FiltersScreen extends StatelessWidget {
  FiltersScreen({super.key});

  final FiltersController controller = Get.put(FiltersController());

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
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.categories.isEmpty) {
                  return const Center(child: Text('No activities found'));
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 118 / 90,
                  ),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return _buildActivityCard(
                      category.name,
                      category.icon,
                      category.name,
                    );
                  },
                );
              }),

              // Difficulty Section
              const SizedBox(height: 16),
              const TextWidget(
                text: 'Difficulty',
                // style: TextStyle(
                //   fontSize: 16,
                //   fontWeight: FontWeight.w600,
                //   color: Colors.black,
                // ),
                fontColor: AppColor.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 16),
              Obx(() => SingleChildScrollView(
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
                  )),

              const SizedBox(height: 15),

              // Distance Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Distance:',
                    // style: TextStyle(
                    //   fontSize: 16,
                    //   fontWeight: FontWeight.w400,
                    //   color: AppColor.subTitleColor,
                    // ),
                    fontColor: AppColor.subTitleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  Obx(() => Text(
                        '${controller.distanceValue.value.toInt()}km to +250km',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      )),
                ],
              ),
              Obx(() => SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF2E5233),
                      inactiveTrackColor: Colors.grey[300],
                      thumbColor: const Color(0xFF2E5233),
                      overlayColor:
                          const Color(0xFF2E5233).withValues(alpha: 0.2),
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 10),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: controller.distanceValue.value,
                      min: 0,
                      max: 250,
                      onChanged: (value) {
                        controller.setDistanceValue(value);
                      },
                    ),
                  )),

              // Type of route Section
              const TextWidget(
                text: 'Type of route',
                fontColor: AppColor.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 16),
              Obx(() => Row(
                    children: [
                      Expanded(
                        child: _buildRouteTypeChip('Circular'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildRouteTypeChip('Round trip'),
                      ),
                    ],
                  )),

              const SizedBox(height: 50),

              // Apply Filters Button
              Center(
                child: Obx(() => ButtonWidget(
                      onPressed: () => controller.applyFilters(),
                      backgroundColor: AppColor.backgroundColor,
                      label: 'Apply Filters',
                      buttonWidth: double.infinity,
                      isLoading: controller.isLoading.value,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(String title, String imageIcon, String value) {
    return Obx(() {
      final isSelected = controller.selectedActivity.value == value;
      return GestureDetector(
        onTap: () {
          controller.selectActivity(value);
        },
        child: Container(
          decoration: BoxDecoration(
            color:
                isSelected ? AppColor.soilColor : AppColor.lightGrayishOrange,
            borderRadius: BorderRadius.circular(12.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageIcon.startsWith('http') || imageIcon.startsWith('/'))
                Image.network(
                  imageIcon.startsWith('http')
                      ? imageIcon
                      : '${AppApiEndPoint.domain}$imageIcon',
                  height: 40.h,
                  width: 40.w,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                )
              else
                Image.asset(
                  imageIcon,
                  height: 40.h,
                  width: 40.w,
                ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: TextWidget(
                  text: title,
                  fontColor:
                      isSelected ? AppColor.darkGray500 : AppColor.darkGray400,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDifficultyChip(String difficulty) {
    final isSelected = controller.selectedDifficulty.value == difficulty;
    return GestureDetector(
      onTap: () {
        controller.selectDifficulty(difficulty);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.soilColor : Color(0xFFF5E9DF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextWidget(
          text: difficulty,
          fontColor: AppColor.textColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildRouteTypeChip(String routeType) {
    final isSelected = controller.selectedRouteType.value == routeType;
    return GestureDetector(
      onTap: () {
        controller.selectRouteType(routeType);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.soilColor : AppColor.lightGrayishOrange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextWidget(
          text: routeType,
          textAlignment: TextAlign.center,
          fontColor: AppColor.textColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
