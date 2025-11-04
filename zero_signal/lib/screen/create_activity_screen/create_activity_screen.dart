import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../constant/app_colors.dart';
import '../../gen/assets.gen.dart';
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
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,

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
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(text: 'Activity Title',fontWeight: FontWeight.w400,),
            SizedBox(
              height: 8.h,
            ),
            TextFieldWidget(
              textColor:Color(0xFF484949),
              hintText: 'Title of the activity',
              borderColor: Colors.transparent,
              backgroundColor: AppColor.lightGrayishOrange,
              borderRadius: 8,
            ),

            const SizedBox(height: 12),

            TextWidget(text: 'Date',fontWeight: FontWeight. w400,),
            SizedBox(
              height: 8.h,
            ),
            TextFieldWidget(
              customSuffixIcon: Image.asset(Assets.icons.calender.path, height: 18.h,width: 18.w,),
              hintText: 'dd/mm/yyyy',
              borderColor: Colors.transparent,
              backgroundColor: AppColor.lightGrayishOrange,
              borderRadius: 8,
            ),

            const SizedBox(height: 12),

            TextWidget(
              textAlignment: TextAlign.start,
              text: 'Do you want to do a route of your favorites?',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(
              height: 8.h,
            ),
            CustomDropdown<String>(
              items: [],
              hint: 'Select route',
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

            TextWidget(text: 'Location',fontWeight: FontWeight. w400,),


             SizedBox(height: 8.h),
            TextFieldWidget(
              customSuffixIcon: Icon(Icons.close,color: AppColor.backgroundColor),
              prefixIcon: Icon(Icons.search,color: AppColor.yello,size: 18,),
              hintText: 'Search place (Google Maps)',
              borderColor: Colors.transparent,
              backgroundColor: AppColor.lightGrayishOrange,
              borderRadius: 12,
            ),

            SizedBox(height: 12,),

            TextWidget(text: 'Activity Type',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),

            SizedBox(
              height: 8.h,
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
                'Other'
              ],
              hint: 'Select type',
              selectedValue: selectedValue,
              borderRadius: 8,
              onChanged: (value) {

                selectedValue = value;
              },
              borderColor: AppColor.creamBackgroundColor,
              dropdownColor: AppColor.lightGrayishOrange,
              boxColor: AppColor.lightGrayishOrange,
            ),

            SizedBox(height: 12,),

            TextWidget(text: 'Description',fontWeight: FontWeight.w400,),

            SizedBox(height: 8.h),
            TextFieldWidget(
              hintText: 'Description of the activity ',
              minLines: 4,
              maxLines: 5,
              borderColor: Colors.transparent,
              backgroundColor: AppColor.lightGrayishOrange,
              borderRadius: 12,
            ),

            SizedBox(height: 12,),

            _uploadImagesBox(),
            Align(
              alignment: Alignment.bottomRight,
              child: TextWidget(text: 'max 5 photos',
                fontColor: AppColor.yello,
                textAlignment: TextAlign.end,
              ),
            ),


            SizedBox(height: 12.h,),

            TextWidget(

              text: 'Maximum Number of Attendees',fontWeight: FontWeight.w400,),
            TextFieldWidget(
              hintText: 'Enter Number',
              borderColor: Colors.transparent,
              backgroundColor: AppColor.lightGrayishOrange,
              borderRadius: 12,
            ),



            SizedBox(height: 30.h,),



            Center(
              child: ButtonWidget(
                onPressed: (){
                  Navigator.pop(context);
                },
                buttonWidth: double.infinity,
                backgroundColor: AppColor.backgroundColor,
                label: 'Publish',
              ),
            ),


            SizedBox(height: 30.h),

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
