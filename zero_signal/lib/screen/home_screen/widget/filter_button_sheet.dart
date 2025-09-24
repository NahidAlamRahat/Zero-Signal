import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constant/app_colors.dart';
import '../../../widget/button_widget/button_widget.dart';
import '../conntroller/filter_controller.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FilterController>();

    return Container(
      decoration: const BoxDecoration(
        color: AppColor.creamBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 24),
                  color: Colors.black,
                ),
              ],
            ),
          ),

          // Filter content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GetBuilder<FilterController>(
                builder: (controller) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Build each category
                    ...controller.filterCategories.entries.map((category) {
                      return _buildFilterCategory(
                          controller, category.key, category.value);
                    }).toList(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    buttonWidth: 10,
                    backgroundColor: Colors.transparent,
                    label: "Clear All",
                    buttonHeight: 48,
                    textColor: AppColor.yello,
                    onPressed: () {
                      controller.clearAll();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ButtonWidget(
                    buttonWidth: 10,
                    backgroundColor: AppColor.backgroundColor,
                    label: "Show Results",
                    buttonHeight: 48,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context, controller.selectedFilters);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCategory(
      FilterController controller, String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = controller.selectedFilters.contains(option);
            return GestureDetector(
              onTap: () => controller.toggleFilter(option),
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(20),
                shadowColor: Colors.black26,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.backgroundColor
                        : AppColor.creamBackgroundColor,
                    border: Border.all(
                      color: isSelected
                          ? AppColor.backgroundColor
                          : const Color(0xFFD6C8B0),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
