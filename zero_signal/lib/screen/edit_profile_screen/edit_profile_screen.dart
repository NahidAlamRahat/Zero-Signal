import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/utils/date_input_formatter.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';

import '../../constant/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../widget/text_widget/text_widgets.dart';
import '../profile/controller/profile_controller.dart';
import '../sport_details/widget/date_picker_sheet.dart';
import '../../constant/api_end_point.dart';
import 'controller/edit_profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
      init: EditProfileController(),
      builder: (controller) {
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      spacing: 20,
                      children: [
                        _buildProfileImage(controller),
                        _buildFormFields(controller),
                        _buildSaveButton(controller),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(EditProfileController controller) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: const Color(0xFF484949), width: 3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: controller.imageFile != null
                ? Image.file(
                    controller.imageFile!,
                    fit: BoxFit.cover,
                  )
                : (Get.find<ProfileController>().userImage.value.isNotEmpty
                    ? Image.network(
                        AppApiEndPoint.domain +
                            Get.find<ProfileController>().userImage.value,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(AppImagePath.profileImage,
                                fit: BoxFit.cover),
                      )
                    : Image.asset(AppImagePath.profileImage,
                        fit: BoxFit.cover)),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              controller.pickImage();
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

  Widget _buildFormFields(EditProfileController controller) {
    return Column(
      spacing: 16,
      children: [
        _buildTextField('Full Name', controller.nameController),
        _buildTextField('Me in one sentence', controller.oneLineBioController),
        _buildTextField(
          'Description',
          controller.descriptionController,
          maxLines: 4,
          height: 100,
        ),
        _buildTextField('Email', controller.emailController, readOnly: true),
        _buildDropdownField(
            'Gender', controller.genderController, ['Male', 'Female', 'Other']),
        _buildDateField('Date of birth', controller.dobController),
        _buildTextField('Address', controller.addressController),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    double? height,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        TextWidget(
          text: label,
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
          child: TextFieldWidget(
            controller: controller,
            maxLines: maxLines,
            backgroundColor: readOnly
                ? AppColor.lightGrayishOrange
                : AppColor.overLayBoxColor,
            fontWeight: FontWeight.w400,
            hintColor: AppColor.textColor,
            textColor: AppColor.textColor,
            borderColor: AppColor.overLayBoxColor,
            fontSize: 14,
            borderRadius: 8,
            readOnly: readOnly,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
      String label, TextEditingController controller, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        TextWidget(
          text: label,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontColor: AppColor.textColor,
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5E9DF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: options.contains(controller.text) ? controller.text : null,
            style: TextStyle(
              color: AppColor.textColor,
              fontSize: 14,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w400,
            ),
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
              controller.text = newValue ?? '';
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
          text: label,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontColor: AppColor.textColor,
        ),
        TextFieldWidget(
          hintColor: AppColor.subTitleColor,
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [DateInputFormatter()],
          customSuffixIcon: InkWell(
              onTap: () async {
                final selectedDate = await showDatePickerSheet(context);
                if (selectedDate != null) {
                  controller.text =
                      DateFormat('yyyy-MM-dd').format(selectedDate);
                }
              },
              child: Image.asset(
                Assets.icons.calender.path,
                height: 18.h,
                width: 18.w,
              )),
          hintText: 'yyyy-mm-dd',
          borderColor: Colors.transparent,
          backgroundColor: AppColor.lightGrayishOrange,
          borderRadius: 8,
        ),
      ],
    );
  }

  Widget _buildSaveButton(EditProfileController controller) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      child: Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () {
                    controller.updateProfile();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E4F3E),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Save & Continue',
                    style: TextStyle(
                      color: Color(0xFFF1F1F1),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          )),
    );
  }

  Future<DateTime?> showDatePickerSheet(BuildContext context) async {
    return await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Container(
          width: Get.width,
          color: AppColor.creamBackgroundColor,
          child: const DatePickerSheet(),
        ),
      ),
    );
  }
}
