import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constant/app_colors.dart';
import '../conntroller/filter_controller.dart';

class FilterBottomSheet extends StatelessWidget {
  FilterBottomSheet({super.key}) {
    if (!Get.isRegistered<FilterController>()) {
      Get.lazyPut(() => FilterController());
    }
  }

  FilterController get controller => Get.find<FilterController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFFEFEAE0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(context),
          
          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[300],
          ),
          
          // Content
          Expanded(
            child: GetBuilder<FilterController>(
              builder: (controller) {
                if (controller.isLoading) {
                  return _buildLoadingState();
                }
                
                if (controller.errorMessage.isNotEmpty) {
                  return _buildErrorState(controller);
                }
                
                return _buildContent(controller);
              },
            ),
          ),
          
          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[300],
          ),
          
          // Bottom buttons
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 20.h),
      child: Stack(
        children: [
          // Center title
          Align(
            alignment: Alignment.center,
            child: Text(
              'Filters',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2C2C2C),
                letterSpacing: -0.3,
              ),
            ),
          ),
          // Close button on right
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.all(4.w),
                child: Icon(
                  Icons.close,
                  size: 24.w,
                  color: const Color(0xFF2C2C2C),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColor.backgroundColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading filters...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(FilterController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.w,
              color: Colors.red[400],
            ),
            SizedBox(height: 16.h),
            Text(
              controller.errorMessage,
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => controller.refreshCategories(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.backgroundColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(FilterController controller) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      children: controller.filterCategories.entries.map((category) {
        return _buildCategorySection(
          controller,
          category.key,
          category.value,
        );
      }).toList(),
    );
  }

  Widget _buildCategorySection(
    FilterController controller,
    String title,
    List<String> options,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category title
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2C2C2C),
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 14.h),
          
          // Filter chips
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: options.map((option) {
              final isSelected = controller.selectedFilters.contains(option);
              return _buildFilterChip(controller, option, isSelected);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    FilterController controller,
    String label,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => controller.toggleFilter(label),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 18.w,
          vertical: 11.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3A5A4D) : const Color(0xFFE5DED0),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF3A5A4D) : const Color(0xFFD4CCC0),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF2C2C2C),
            letterSpacing: -0.1,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
      child: Row(
        children: [
          // Clear All button
          GestureDetector(
            onTap: () => controller.clearAll(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
              child: Text(
                'Clear All',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.yello,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
          
          const Spacer(),
          
          // Show Results button
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.delete<FilterController>();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3A5A4D),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 32.w,
                vertical: 15.h,
              ),
            ),
            child: Text(
              'Show Results',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}