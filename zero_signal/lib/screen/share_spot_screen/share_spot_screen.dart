import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/screen/share_spot_screen/widget/location_search_widget.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../constant/app_colors.dart';
import 'controller/share_spot_controller.dart';
import 'model/category_response_model.dart';

class ShareSpotScreen extends StatelessWidget {
  const ShareSpotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShareSpotController>(
      init: ShareSpotController(),
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
              text: 'Share a New Spot',
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
                  hintText: 'Enter a tile',
                ),
                const SizedBox(height: 24),
                // Location
                _sectionTitle('Location'),
                SizedBox(height: 12.h),
                const LocationSearchWidget(),
                SizedBox(height: 24.h),

                // Description
                _sectionTitle('Description'),
                SizedBox(height: 12.h),
                _descriptionBox(controller),
                SizedBox(height: 24.h),

                // Type Spot
                _sectionTitle('Type Spot'),
                SizedBox(height: 12.h),
                _typeDropdown(controller),
                if (controller.isDropdownOpen) _dropdownBody(controller),
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
                    : () => controller.submitSpot(),
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

  Widget _uploadImagesBox(ShareSpotController controller) {
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
                        color: Colors.white.withOpacity(0.5),
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

  Widget _descriptionBox(ShareSpotController controller) => Container(
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
            hintText: 'Enter a description...',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      );

  Widget _typeDropdown(ShareSpotController controller) => GestureDetector(
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

  Widget _dropdownBody(ShareSpotController controller) => Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: 400),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildAllCategories(controller),
          ),
        ),
      );

  List<Widget> _buildAllCategories(ShareSpotController controller) {
    final widgets = <Widget>[];
    for (var category in controller.categories) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12, top: 16),
          child: Text(
            '${category.name}:',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      );
      for (int i = 0; i < category.subcategories.length; i++) {
        widgets.add(_dropdownCheckboxTile(
          category.subcategories[i],
          category.id,
          i,
          controller,
        ));
        if (i < category.subcategories.length - 1) {
          widgets.add(const SizedBox(height: 8));
        }
      }
    }
    return widgets;
  }

  Widget _dropdownCheckboxTile(
    SubcategoryData item,
    String categoryId,
    int index,
    ShareSpotController controller,
  ) =>
      GestureDetector(
        onTap: () => controller.toggleSubcategorySelection(categoryId, index),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 1.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: item.isSelected
                  ? const Icon(Icons.check, size: 16, color: Color(0xFF2D5A3D))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.name,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
          ],
        ),
      );






}
