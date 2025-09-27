import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/routes/app_routes.dart';
import 'package:zero_signal/screen/share_spot_screen/widget/confirm_location_sheet.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';

import '../../constant/app_colors.dart';

class SaveRouteScreen extends StatefulWidget {
  const SaveRouteScreen({super.key});

  @override
  _SaveRouteScreenState createState() => _SaveRouteScreenState();
}

class _SaveRouteScreenState extends State<SaveRouteScreen> {
  String selectedType = 'Choose types';
  bool isDropdownOpen = false;
  TextEditingController descriptionController = TextEditingController();

  // All spot types with categories
  Map<String, List<Map<String, dynamic>>> allSpotTypes = {
    'Natural & landscape:': [
      {'name': 'View Points', 'selected': false},
      {'name': 'Natural Pool', 'selected': false},
      {'name': 'River', 'selected': false},
      {'name': 'Cove', 'selected': false},
      {'name': 'Waterfall', 'selected': false},
      {'name': 'Monumental Trees', 'selected': false},
      {'name': 'Natural Spring', 'selected': false},
      {'name': 'Swamp', 'selected': false},
      {'name': 'Thermal Water', 'selected': false},
    ],
    'Overnight & Rest:': [
      {'name': 'Wild Rest Area', 'selected': false},
      {'name': 'Hostel', 'selected': false},
      {'name': 'Camper Area', 'selected': false},
      {'name': 'Shelter', 'selected': false},
      {'name': 'Picnic Area', 'selected': false},
      {'name': 'Bivouac Area', 'selected': false},
    ],
    'Exploration & Adventure:': [
      {'name': 'Mines', 'selected': false},
      {'name': 'Caves', 'selected': false},
      {'name': 'Hanging Bridges', 'selected': false},
      {'name': 'Tunnels', 'selected': false},
      {'name': 'Hidden Passages', 'selected': false},
    ],
    'History & Culture:': [
      {'name': 'Historical Sites', 'selected': false},
      {'name': 'Hermitages', 'selected': false},
      {'name': 'Monuments', 'selected': false},
      {'name': 'Ruins', 'selected': false},
    ],
    'Curiosity & Unique Places:': [
      {'name': 'Curious Rock Formations', 'selected': false},
      {'name': 'Geodesic Vortex', 'selected': false},
      {'name': 'Astronomical viewpoints', 'selected': false},
      {'name': 'Wildlife observation points', 'selected': false},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.creamBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.creamBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Save Route',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload Images
            _uploadImagesBox(),
            const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Max 10',
                  style: TextStyle(
                    color: AppColor.yello,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Location
            _sectionTitle('Location'),
            const SizedBox(height: 12),
            _setLocationBox(),
            const SizedBox(height: 24),

            // Description
            _sectionTitle('Description'),
            const SizedBox(height: 12),
            _descriptionBox(),
            const SizedBox(height: 24),

            // Type Spot
            _sectionTitle('Type Spot'),
            const SizedBox(height: 12),
            _typeDropdown(),
            if (isDropdownOpen) _dropdownBody(),
            const SizedBox(height: 60),

            // Submit
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
          child: ButtonWidget(
            buttonWidth: double.infinity,
            onPressed: () {
              Get.toNamed(AppRoutes.spotDetailsScreen);
            },
            label: 'Submit for Review',
            backgroundColor: AppColor.backgroundColor,
          ),
        ),
      ),
    );
  }


  // ------------------------------ helpers ------------------------------



  void showConfirmLocationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      // Background transparent rakha hocche
      builder: (BuildContext context) {
        return const ConfirmLocationSheet();
      },
    );
  }

  Widget _uploadImagesBox() => Container(
    width: double.infinity,
    height: 120,
    decoration: BoxDecoration(
      color: Color.fromRGBO(245, 233, 223, 1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Color.fromRGBO(245, 233, 223, 1)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey.shade600),
        const SizedBox(height: 8),
        Text(
          'Upload Images',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
      ],
    ),
  );

  Widget _sectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
  );

  Widget _setLocationBox() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    decoration: BoxDecoration(
      color: Color.fromRGBO(245, 233, 223, 1),

      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Color.fromRGBO(245, 233, 223, 1)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Set Location',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
        InkWell(
          onTap: () {
            showConfirmLocationSheet(context);
          },
          child: Image.asset(AppIconPath.map, height: 16.h, width: 16.w),
        ),
      ],
    ),
  );

  Widget _descriptionBox() => Container(
    width: double.infinity,
    height: 80,
    decoration: BoxDecoration(
      color: Color.fromRGBO(245, 233, 223, 1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Color.fromRGBO(245, 233, 223, 1)),
    ),
    child: TextField(
      controller: descriptionController,
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

  Widget _typeDropdown() => GestureDetector(
    onTap: () => setState(() => isDropdownOpen = !isDropdownOpen),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Color.fromRGBO(245, 233, 223, 1),
        borderRadius: isDropdownOpen
            ? const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        )
            : BorderRadius.circular(12),
        border: Border.all(color: Color.fromRGBO(245, 233, 223, 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedType,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
          Icon(
            isDropdownOpen
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    ),
  );

  Widget _dropdownBody() => Container(
    width: double.infinity,
    constraints: const BoxConstraints(maxHeight: 400),
    decoration: BoxDecoration(
      color: Color.fromRGBO(245, 233, 223, 1),
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
        children: _buildAllCategories(),
      ),
    ),
  );

  List<Widget> _buildAllCategories() {
    final widgets = <Widget>[];
    allSpotTypes.forEach((category, items) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12, top: 16),
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      );
      for (int i = 0; i < items.length; i++) {
        widgets.add(_dropdownCheckboxTile(items[i], category, i));
        if (i < items.length - 1) widgets.add(const SizedBox(height: 8));
      }
    });
    return widgets;
  }

  Widget _dropdownCheckboxTile(
      Map<String, dynamic> item,
      String category,
      int index,
      ) => GestureDetector(
    onTap: () => setState(() {
      allSpotTypes[category]![index]['selected'] =
      !allSpotTypes[category]![index]['selected'];
    }),
    child: Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400, width: 1.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: item['selected']
              ? const Icon(Icons.check, size: 16, color: Color(0xFF2D5A3D))
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            item['name'],
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
      ],
    ),
  );



  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}