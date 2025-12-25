import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/app_colors.dart';
import '../controller/share_route_controller.dart';
import '../../../widget/text_widget/text_widgets.dart';
import 'map_location_picker_widget.dart';

class LocationSearchWidget extends StatelessWidget {
  final bool isStartLocation;
  final String hintText;

  const LocationSearchWidget({
    super.key,
    required this.isStartLocation,
    this.hintText = 'Enter location',
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShareRouteController>(
      builder: (controller) {
        final suggestions = isStartLocation
            ? controller.startLocationSuggestions
            : controller.endLocationSuggestions;
        final textController = isStartLocation
            ? controller.startLocationController
            : controller.endLocationController;
        final isSearching = isStartLocation
            ? controller.isStartLocationSearching
            : controller.isEndLocationSearching;

        return Column(
          children: [
            // Search input field
            Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(245, 233, 223, 1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color.fromRGBO(245, 233, 223, 1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        if (isStartLocation) {
                          controller.searchStartLocation(value);
                        } else {
                          controller.searchEndLocation(value);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                        prefixIcon: Icon(
                          isStartLocation ? Icons.location_on : Icons.flag,
                          color: AppColor.backgroundColor,
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Map picker button
                            IconButton(
                              icon: const Icon(Icons.map,
                                  color: AppColor.backgroundColor),
                              onPressed: () => _showMapPicker(context, controller),
                              tooltip: 'Pick from map',
                            ),
                            // Current location button
                            if (!isSearching)
                              IconButton(
                                icon: const Icon(Icons.my_location,
                                    color: AppColor.backgroundColor),
                                onPressed: () {
                                  if (isStartLocation) {
                                    controller.getCurrentStartLocation();
                                  } else {
                                    controller.getCurrentEndLocation();
                                  }
                                },
                                tooltip: 'Use current location',
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Location suggestions dropdown
            if (suggestions.isNotEmpty)
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxHeight: 200),
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = suggestions[index];
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.place,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      title: Text(
                        suggestion.placeName,
                        style: const TextStyle(fontSize: 14),
                      ),
                      subtitle: suggestion.text != suggestion.placeName
                          ? Text(
                              suggestion.text,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            )
                          : null,
                      onTap: () {
                        if (isStartLocation) {
                          controller.selectStartLocation(suggestion);
                        } else {
                          controller.selectEndLocation(suggestion);
                        }
                      },
                    );
                  },
                ),
              ),

            // Selected coordinates display
            if (isStartLocation &&
                controller.startLat != null &&
                controller.startLng != null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: 'Start Latitude',
                              fontColor: AppColor.blackColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            SizedBox(height: 8.h),
                            _coordinateBox(controller.startLat.toString()),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: 'Start Longitude',
                              fontColor: AppColor.blackColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            SizedBox(height: 8.h),
                            _coordinateBox(controller.startLng.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                ],

                if (!isStartLocation &&
                    controller.endLat != null &&
                    controller.endLng != null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: 'End Latitude',
                              fontColor: AppColor.blackColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            SizedBox(height: 8.h),
                            _coordinateBox(controller.endLat.toString()),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: 'End Longitude',
                              fontColor: AppColor.blackColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            SizedBox(height: 8.h),
                            _coordinateBox(controller.endLng.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                ],
          ],
        );
      },
    );
  }

  void _showMapPicker(BuildContext context, ShareRouteController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(
                      isStartLocation ? Icons.location_on : Icons.flag,
                      color: isStartLocation ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Select ${isStartLocation ? 'Start' : 'End'} Location',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1),
              
              // Map picker
              Expanded(
                child: MapLocationPickerWidget(
                  isStartLocation: isStartLocation,
                  initialLat: isStartLocation ? controller.startLat : controller.endLat,
                  initialLng: isStartLocation ? controller.startLng : controller.endLng,
                ),
              ),
              
              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tap on the map to select ${isStartLocation ? 'start' : 'end'} location',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _coordinateBox(String value) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(245, 233, 223, 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
}
