import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/screen/share_route_screen/widget/location_search_widget.dart';

import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import 'package:zero_signal/constant/app_strings.dart';
import '../../constant/app_colors.dart';
import 'controller/share_route_controller.dart';
import '../filters_screen/model/route_category_model.dart';

class ShareRouteScreen extends StatelessWidget {
  const ShareRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShareRouteController>(
      init: ShareRouteController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.creamBackgroundColor,
          appBar: AppBar(
            backgroundColor: AppColor.creamBackgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const TextWidget(
              text: 'Share a New Route',
              fontWeight: FontWeight.w500,
              fontSize: 20,
              fontColor: AppColor.blackColor,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upload Images
                _uploadImagesBox(controller),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextWidget(
                      text: '${controller.selectedImages.length}/10',
                      fontColor: AppColor.yello,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                _sectionTitle('Title'),
                SizedBox(height: 12.h),
                TextFieldWidget(
                  controller: controller.titleController,
                  borderColor: AppColor.overLayBoxColor,
                  borderRadius: 12,
                  focusedBorderColor: AppColor.overLayBoxColor,
                  backgroundColor: AppColor.overLayBoxColor,
                  hintText: AppStrings.enterRouteTitle,
                ),
                const SizedBox(height: 24),

                // Start Location
                _sectionTitle('Start Location'),
                SizedBox(height: 12.h),
                LocationSearchWidget(
                  isStartLocation: true,
                  hintText: AppStrings.enterStartLocation,
                ),
                SizedBox(height: 24.h),

                // End Location
                _sectionTitle('End Location'),
                SizedBox(height: 12.h),
                LocationSearchWidget(
                  isStartLocation: false,
                  hintText: AppStrings.enterEndLocation,
                ),
                SizedBox(height: 24.h),

                // Description
                _sectionTitle('Description'),
                SizedBox(height: 12.h),
                _descriptionBox(controller),
                SizedBox(height: 24.h),

                // Type Route
                _sectionTitle('Type Route'),
                SizedBox(height: 12.h),
                _typeDropdown(controller),
                if (controller.isDropdownOpen) _dropdownBody(controller),
                SizedBox(height: 24.h),

                // Route Type
                _sectionTitle('Route Type'),
                SizedBox(height: 12.h),
                _routeTypeDropdown(controller),
                if (controller.isRouteTypeDropdownOpen)
                  _routeTypeDropdownBody(controller),
                SizedBox(height: 24.h),

                // Difficulty
                _sectionTitle('Difficulty'),
                SizedBox(height: 12.h),
                _difficultyDropdown(controller),
                if (controller.isDifficultyDropdownOpen)
                  _difficultyDropdownBody(controller),
                SizedBox(height: 60.h),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
              child: ButtonWidget(
                buttonWidth: double.infinity,
                onPressed: controller.isSubmitting
                    ? null
                    : () => controller.submitRoute(),
                label: controller.isSubmitting
                    ? 'Submitting...'
                    : 'Submit for Review',
                backgroundColor: AppColor.backgroundColor,
              ),
            ),
          ),
        );
      },
    );
  }

  // ------------------------------ helpers ------------------------------

  Widget _uploadImagesBox(ShareRouteController controller) {
    if (controller.selectedImages.isEmpty) {
      return GestureDetector(
        onTap: () => controller.pickImages(),
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(245, 233, 223, 1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color.fromRGBO(245, 233, 223, 1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppIconPath.cameraIcon, height: 24, width: 24),
              const SizedBox(height: 8),
              const TextWidget(
                text: 'Upload Image',
                fontColor: AppColor.blackColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ],
          ),
        ),
      );
    }

    // Show selected images grid
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(245, 233, 223, 1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color.fromRGBO(245, 233, 223, 1)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.selectedImages.length +
                  (controller.selectedImages.length < 10 ? 1 : 0),
              itemBuilder: (context, index) {
                // Add button at end
                if (index == controller.selectedImages.length) {
                  return GestureDetector(
                    onTap: () => controller.pickImages(),
                    child: Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add,
                              color: Colors.grey.shade600, size: 24),
                          const SizedBox(height: 4),
                          Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Image tile
                return Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(controller.selectedImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => controller.removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) => TextWidget(
        text: title,
        fontColor: AppColor.blackColor,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      );

  Widget _descriptionBox(ShareRouteController controller) => Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(245, 233, 223, 1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color.fromRGBO(245, 233, 223, 1)),
        ),
        child: TextField(
          controller: controller.descriptionController,
          maxLines: null,
          expands: true,
          decoration: InputDecoration(
            hintText: AppStrings.enterDescriptionHint,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      );

  Widget _typeDropdown(ShareRouteController controller) => GestureDetector(
        onTap: () => controller.toggleDropdown(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(245, 233, 223, 1),
            borderRadius: controller.isDropdownOpen
                ? const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  )
                : BorderRadius.circular(12),
            border: Border.all(color: const Color.fromRGBO(245, 233, 223, 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (controller.isCategoriesLoading)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.grey.shade600,
                  ),
                )
              else
                Expanded(
                  child: Text(
                    controller.selectedTypeName,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              Icon(
                controller.isDropdownOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      );

  Widget _dropdownBody(ShareRouteController controller) => Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: 300),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(245, 233, 223, 1),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          border: Border.all(color: const Color.fromRGBO(245, 233, 223, 1)),
        ),
        child: controller.routeCategories.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: TextWidget(text: 'No activities found'),
              )
            : ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.routeCategories.length,
                itemBuilder: (context, index) {
                  final category = controller.routeCategories[index];
                  return _dropdownTile(category, controller);
                },
              ),
      );

  Widget _dropdownTile(
    RouteCategoryModel item,
    ShareRouteController controller,
  ) {
    final isSelected = controller.selectedCategoryId == item.id;
    return ListTile(
      onTap: () => controller.selectRouteCategory(item),
      leading: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400, width: 1.5),
          borderRadius: BorderRadius.circular(4),
          color: isSelected ? const Color(0xFF2D5A3D) : Colors.transparent,
        ),
        child: isSelected
            ? const Icon(Icons.check, size: 14, color: Colors.white)
            : null,
      ),
      title: Text(
        item.name,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
      ),
    );
  }

  Widget _routeTypeDropdown(ShareRouteController controller) => GestureDetector(
        onTap: () => controller.toggleRouteTypeDropdown(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(245, 233, 223, 1),
            borderRadius: controller.isRouteTypeDropdownOpen
                ? const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  )
                : BorderRadius.circular(12),
            border: Border.all(color: const Color.fromRGBO(245, 233, 223, 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  controller.selectedRouteType == 'roundtrip'
                      ? 'Round Trip'
                      : 'Circle Trip',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                controller.isRouteTypeDropdownOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      );

  Widget _routeTypeDropdownBody(ShareRouteController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(245, 233, 223, 1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border(
          left: BorderSide(color: Colors.grey.shade300),
          right: BorderSide(color: Colors.grey.shade300),
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        children: controller.routeTypes.map((routeType) {
          return ListTile(
            dense: true,
            title: Text(
              routeType == 'roundtrip' ? 'Round Trip' : 'Single Trip',
              style: TextStyle(
                fontSize: 15,
                color: controller.selectedRouteType == routeType
                    ? const Color(0xFF2D5A3D)
                    : Colors.black87,
                fontWeight: controller.selectedRouteType == routeType
                    ? FontWeight.w500
                    : FontWeight.normal,
              ),
            ),
            trailing: controller.selectedRouteType == routeType
                ? const Icon(Icons.check, color: Color(0xFF2D5A3D), size: 20)
                : null,
            onTap: () => controller.selectRouteType(routeType),
          );
        }).toList(),
      ),
    );
  }

  Widget _difficultyDropdown(ShareRouteController controller) =>
      GestureDetector(
        onTap: () => controller.toggleDifficultyDropdown(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(245, 233, 223, 1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  controller.selectedDifficulty == 'easy'
                      ? 'Easy'
                      : controller.selectedDifficulty == 'medium'
                          ? 'Medium'
                          : 'Hard',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                controller.isDifficultyDropdownOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      );

  Widget _difficultyDropdownBody(ShareRouteController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(245, 233, 223, 1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border(
          left: BorderSide(color: Colors.grey.shade300),
          right: BorderSide(color: Colors.grey.shade300),
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        children: controller.difficultyLevels.map((difficulty) {
          return ListTile(
            dense: true,
            title: Text(
              difficulty == 'easy'
                  ? 'Easy'
                  : difficulty == 'medium'
                      ? 'Medium'
                      : 'Hard',
              style: TextStyle(
                fontSize: 15,
                color: controller.selectedDifficulty == difficulty
                    ? const Color(0xFF2D5A3D)
                    : Colors.black87,
                fontWeight: controller.selectedDifficulty == difficulty
                    ? FontWeight.w500
                    : FontWeight.normal,
              ),
            ),
            trailing: controller.selectedDifficulty == difficulty
                ? const Icon(Icons.check, color: Color(0xFF2D5A3D), size: 20)
                : null,
            onTap: () => controller.selectDifficulty(difficulty),
          );
        }).toList(),
      ),
    );
  }
}
