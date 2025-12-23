import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zero_signal/repository/profile_repository.dart';
import 'package:zero_signal/screen/profile/controller/profile_controller.dart';
import 'package:zero_signal/service/api_service/api_services.dart';
import 'package:zero_signal/widget/app_snack_bar/app_snack_bar.dart';

class EditProfileController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();
  final ProfileController _profileController = Get.find<ProfileController>();

  final nameController = TextEditingController();
  final oneLineBioController = TextEditingController();
  final descriptionController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();

  File? imageFile;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _populateFields();
  }

  void _populateFields() {
    nameController.text = _profileController.userName.value;
    emailController.text = _profileController.userEmail.value;
    oneLineBioController.text = _profileController.oneLineBio.value;
    descriptionController.text = _profileController.bio.value;
    genderController.text = _profileController.userGender.value;
    dobController.text = _profileController.userDob.value;
    addressController.text = _profileController.userAddress.value;
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      update();
    }
  }

  Future<void> updateProfile() async {
    isLoading.value = true;

    Map<String, String> body = {
      'name': nameController.text,
      'me_in_one_sentence': oneLineBioController.text,
      'bio': descriptionController.text,
      'gender': genderController.text,
      'date_of_birth': dobController.text,
      'address': addressController.text,
    };

    List<MultipartBody> multipartBody = [];
    if (imageFile != null) {
      multipartBody.add(MultipartBody('image', imageFile!));
    }

    bool success = await _profileRepository.updateProfile(
      body: body,
      multipartBody: multipartBody.isNotEmpty ? multipartBody : null,
    );

    if (success) {
      Get.back();
      _profileController.getProfile();
      AppSnackBar.success("Profile updated successfully");
    }

    isLoading.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    oneLineBioController.dispose();
    descriptionController.dispose();
    emailController.dispose();
    genderController.dispose();
    dobController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
