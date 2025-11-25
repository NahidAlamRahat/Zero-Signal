import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/utils/date_input_formatter.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';

import '../../constant/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../widget/text_widget/text_widgets.dart';
import '../sport_details/widget/date_picker_sheet.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Liam Johnson');
  final TextEditingController _oneSentenceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController(
      text: 'Lam loves to explore new places and experience different cultures. Her heart beats for the thrill of adventure. She finds joy in every journey, whether it\'s wandering through ancient ruins, hiking up a mountain, or simply getting lost in a new city.'
  );
  final TextEditingController _emailController = TextEditingController(text: 'hola@zerosignal.app');
  final TextEditingController _genderController = TextEditingController(text: 'Male');
  final TextEditingController _dobController = TextEditingController(text: '17 dec, 2024');
  final TextEditingController _addressController = TextEditingController(text: '297 Westheimer Rd. Santa Ana');

  TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _oneSentenceController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        backgroundColor: AppColor.creamBackgroundColor,
        text: 'Edit Profile ',
        centerTitle: true,
      ),
      backgroundColor: AppColor.bGColor,
      body: SafeArea(
        child: Column(
          children: [

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  spacing: 20,
                  children: [
                    // Profile Image
                    _buildProfileImage(),

                    // Form Fields
                    _buildFormFields(),

                    // Save Button
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildProfileImage() {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: const Color(0xFF484949), width: 3),
            image: const DecorationImage(
              image: AssetImage(AppImagePath.profileImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              // Handle image edit
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF2E4F3E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.edit,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      spacing: 16,
      children: [
        _buildTextField('Full Name', _nameController),
        _buildTextField('Me in one sentence', _oneSentenceController),
        _buildTextField(
          'Description',
          _descriptionController,
          maxLines: 4,
          height: 100,
        ),
        _buildTextField('Email', _emailController),
        _buildDropdownField('Gender', _genderController, ['Male', 'Female', 'Other']),
        _buildDateField('Date of birth', _dobController),
        _buildTextField('Address', _addressController),
      ],
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        int maxLines = 1,
        double? height,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        TextWidget(
         text:  label,
          // style: const TextStyle(
          //   color: Color(0xFF2C2C2C),
          //   fontSize: 16,
          //   fontFamily: 'Poppins',
          //   fontWeight: FontWeight.w400,
          // ),
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontColor: AppColor.textColor,
        ),
        Container(
          height: height ?? 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF5E9DF),
            borderRadius: BorderRadius.circular(8),
          ),
          // child: TextFormField(
          //   controller: controller,
          //   maxLines: maxLines,
          //   style: const TextStyle(
          //     color: Color(0xFF2C2C2C),
          //     fontSize: 14,
          //     fontFamily: 'Poppins',
          //     fontWeight: FontWeight.w400,
          //   ),
          //   decoration: const InputDecoration(
          //     contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          //     border: InputBorder.none,
          //     hintStyle: TextStyle(
          //       color: Color(0xFF999999),
          //       fontSize: 14,
          //     ),
          //   ),
          // ),
          child: TextFieldWidget(
            controller: controller,
            maxLines: maxLines,
            backgroundColor: AppColor.overLayBoxColor,
            fontWeight: FontWeight.w400,
            hintColor: AppColor.textColor,
            textColor: AppColor.textColor,
            borderColor: AppColor.overLayBoxColor,
            fontSize: 14,
            borderRadius: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, TextEditingController controller, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        TextWidget(
        text:   label,

          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontColor: AppColor.textColor,
        ),
        Container(
          //height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF5E9DF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: controller.text.isNotEmpty ? controller.text : null,
            style: TextStyle(
              color: AppColor.textColor,
              fontSize: 14,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w400,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: InputBorder.none,
            ),
            dropdownColor: AppColor.overLayBoxColor,
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                controller.text = newValue ?? '';
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        TextWidget(
         text:  label,

          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontColor: AppColor.textColor,
        ),


        TextFieldWidget(
          hintColor: AppColor.subTitleColor,
          controller: dateController,
          keyboardType: TextInputType.number,
          inputFormatters: [DateInputFormatter()],
          customSuffixIcon: InkWell(
              onTap: () async {
                final selectedDate = await showDatePickerSheet(context);
                if (selectedDate != null) {
                  setState(() {
                    dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);

                  });
                }
              },
              child: Image.asset(
                Assets.icons.calender.path,
                height: 18.h,
                width: 18.w,
              )),
          hintText: 'dd/mm/yyyy',
          borderColor: Colors.transparent,
          backgroundColor: AppColor.lightGrayishOrange,
          borderRadius: 8,
        ),



      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: () {
          // Handle save action
          _saveProfile();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E4F3E),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Save & Continue',
          style: TextStyle(
            color: Color(0xFFF1F1F1),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }




  void _saveProfile() {
    // Handle profile saving logic here
    print('Name: ${_nameController.text}');
    print('One sentence: ${_oneSentenceController.text}');
    print('Description: ${_descriptionController.text}');
    print('Email: ${_emailController.text}');
    print('Gender: ${_genderController.text}');
    print('DOB: ${_dobController.text}');
    print('Address: ${_addressController.text}');

    // Show success message or navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Color(0xFF2E4F3E),
      ),
    );
  }


  /// Date picker bottom sheet
  Future<DateTime?> showDatePickerSheet(BuildContext context) async {
    return await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Container(
          width: Get.width,
          //   height: Get.height*0.5,
          color: AppColor.creamBackgroundColor,
          child: const DatePickerSheet(),
        ),
      ),
    );
  }



}