import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../constant/app_colors.dart';
import '../../widget/button_widget/button_widget.dart';
import '../../widget/custom_dropdown.dart';

class CreateActivityScreen extends StatefulWidget {
  const CreateActivityScreen({super.key});

  @override
  _CreateActivityScreenState createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  bool isDropdownOpen = false;
  TextEditingController descriptionController = TextEditingController();
  String selectedRouteType = 'Round trip';

  String? selectedValue;


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
          'Create Activity',
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
            TextWidget(text: 'Title',fontWeight: FontWeight.bold,),
            const SizedBox(height: 12),
            TextFieldWidget(

              borderColor: Colors.transparent,
              backgroundColor: AppColor.lightGrayishOrange,
              borderRadius: 12,
            ),
            const SizedBox(height: 12),
            TextWidget(text: 'Description',fontWeight: FontWeight.bold,),
            const SizedBox(height: 12),
            TextFieldWidget(
              minLines: 4,
              maxLines: 5,
              borderColor: Colors.transparent,
              backgroundColor: AppColor.lightGrayishOrange,
              borderRadius: 12,
            ),

            const SizedBox(height: 24),
            TextWidget(text: 'Difficulty',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            CustomDropdown<String>(
              items: [
                'Walking',
                'Hiking',
                'Running',
                'Cycling',
                'Motorcycle',
                'SUV',
                'Road Trip',

              ],
              hint: 'Choose one',
              selectedValue: selectedValue,
              borderRadius: 8,
              onChanged: (value) {

                selectedValue = value;
              },
              borderColor: AppColor.creamBackgroundColor,
              dropdownColor: AppColor.lightGrayishOrange,
              boxColor: AppColor.lightGrayishOrange,
            ),

            const SizedBox(height: 12),
            TextWidget(text: 'Activity',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            CustomDropdown<String>(
              items: [
                'Walking',
                'Hiking',
                'Running',
                'Cycling',
                'Motorcycle',
                'SUV',
                'Road Trip',

              ],
              hint: 'Choose one',
              selectedValue: selectedValue,
              borderRadius: 8,
              onChanged: (value) {

                selectedValue = value;
              },
              borderColor: AppColor.creamBackgroundColor,
              dropdownColor: AppColor.lightGrayishOrange,
              boxColor: AppColor.lightGrayishOrange,
            ),

            SizedBox(height: 20.h,),

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

            SizedBox(height: 20.h,),

            _uploadImagesBox(),
            SizedBox(height: 30.h,),


            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    backgroundColor: Color.fromRGBO(255, 222, 211, 1),
                    buttonHeight: 48,
                    icon: Image.asset(AppIconPath.deleteIcon,width: 20,height: 20,),
                    label: 'Delete',
                    textColor: Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ButtonWidget(
                    backgroundColor: AppColor.backgroundColor,
                    icon: Image.asset(AppIconPath.sendIcon,width: 20,height: 20,),
                    buttonHeight: 48,
                    label: 'Submit',
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }


  // ------------------------------ helpers ------------------------------




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
        Icon(Icons.add, size: 40, color: Colors.grey.shade600),
        const SizedBox(height: 8),
        Text(
          'Add Images',
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



  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}
