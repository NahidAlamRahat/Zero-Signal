import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_icon_path.dart';
import '../controller/share_spot_controller.dart';
import '../model/spot_request_model.dart';
import 'confirm_location_sheet.dart';

/// Location search widget with Mapbox autocomplete suggestions
/// Design matches the existing _setLocationBox style
class LocationSearchWidget extends StatelessWidget {
  const LocationSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShareSpotController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location input box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(245, 233, 223, 1),
                borderRadius: controller.locationSuggestions.isNotEmpty
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      )
                    : BorderRadius.circular(12),
                border:
                    Border.all(color: const Color.fromRGBO(245, 233, 223, 1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.locationController,
                      decoration: InputDecoration(
                        hintText: 'Enter address to search...',
                        hintStyle: TextStyle(
                          color: AppColor.blackColor.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                        color: AppColor.blackColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      onChanged: (value) {
                        controller.searchLocation(value);
                      },
                    ),
                  ),
                  if (controller.isLocationSearching)
                    SizedBox(
                      width: 16.w,
                      height: 16.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.blackColor,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        showConfirmLocationSheet(context);
                      },
                      child: Image.asset(AppIconPath.map, height: 16.h, width: 16.w),
                    ),
                ],
              ),
            ),

            // Suggestions dropdown
            if (controller.locationSuggestions.isNotEmpty)
              Container(
                width: double.infinity,
                constraints: BoxConstraints(maxHeight: 200.h),
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
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: controller.locationSuggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = controller.locationSuggestions[index];
                    return _buildSuggestionItem(
                      suggestion,
                      controller,
                      isLast:
                          index == controller.locationSuggestions.length - 1,
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSuggestionItem(
    MapboxPlaceSuggestion suggestion,
    ShareSpotController controller, {
    bool isLast = false,
  }) {
    return InkWell(
      onTap: () => controller.selectLocation(suggestion),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
                ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 18,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                suggestion.placeName,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }


  void showConfirmLocationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const ConfirmLocationSheet();
      },
    );
  }


}
