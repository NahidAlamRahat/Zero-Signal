import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/repository/support_repository.dart';
import 'package:zero_signal/service/api_service/service_model/service_model.dart';
import 'package:zero_signal/widget/app_snack_bar/app_snack_bar.dart';

class ContactSupportController extends GetxController {
  final SupportRepository _supportRepository = SupportRepository();
  final messageController = TextEditingController();

  final RxList<File> selectedImages = <File>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  Future<void> pickImages() async {
    // Check permission
    PermissionStatus status;
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+), we should use photos permission
      // For older versions, storage permission is used.
      // permission_handler handles some of this mapping.
      status = await Permission.photos.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.photos.request();
    }

    if (status.isGranted || status.isLimited) {
      final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        selectedImages.addAll(pickedFiles.map((xFile) => File(xFile.path)));
      }
    } else if (status.isPermanentlyDenied) {
      Get.dialog(AlertDialog(
        title: const Text(AppStrings.permissionRequired),
        content: const Text(AppStrings.galleryAccessRequired),
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: const Text(AppStrings.cancel)),
          TextButton(
              onPressed: () {
                Get.back();
                openAppSettings();
              },
              child: const Text(AppStrings.settings)),
        ],
      ));
    } else {
      AppSnackBar.error(AppStrings.permissionDeniedGallery);
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> submitSupport() async {
    if (messageController.text.trim().isEmpty) {
      AppSnackBar.error(AppStrings.pleaseEnterMessage);
      return;
    }

    isLoading.value = true;

    ApiResponseModel response = await _supportRepository.createSupport(
      message: messageController.text.trim(),
      images: selectedImages,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      AppSnackBar.success(response.message);
      messageController.clear();
      selectedImages.clear();
      Get.back();
    } else {
      AppSnackBar.error(response.message);
    }

    isLoading.value = false;
  }
}
