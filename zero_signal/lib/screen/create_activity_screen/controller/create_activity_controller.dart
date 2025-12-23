import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zero_signal/repository/activity_repository.dart';
import 'package:zero_signal/screen/create_activity_screen/model/route_type_model.dart';
import 'package:zero_signal/service/api_service/api_services.dart';
import 'package:zero_signal/widget/app_snack_bar/app_snack_bar.dart';

class CreateActivityController extends GetxController {
  final ActivityRepository _repository = ActivityRepository();

  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();
  final maxParticipantsController = TextEditingController();

  var isLoading = false.obs;
  var isRouteTypesLoading = false.obs;
  var routeTypes = <RouteTypeData>[].obs;
  var selectedRouteType = Rxn<RouteTypeData>();

  var selectedImages = <File>[].obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchRouteTypes();
  }

  Future<void> fetchRouteTypes() async {
    isRouteTypesLoading.value = true;
    final model = await _repository.getRouteTypes();
    if (model != null && model.data != null) {
      routeTypes.assignAll(model.data!);
    }
    isRouteTypesLoading.value = false;
  }

  Future<void> pickImages() async {
    if (selectedImages.length >= 5) {
      AppSnackBar.error("You can only select up to 5 images");
      return;
    }

    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      for (var image in images) {
        if (selectedImages.length < 5) {
          selectedImages.add(File(image.path));
        }
      }
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> publishActivity() async {
    if (titleController.text.isEmpty ||
        dateController.text.isEmpty ||
        selectedRouteType.value == null ||
        descriptionController.text.isEmpty ||
        maxParticipantsController.text.isEmpty) {
      AppSnackBar.error("Please fill all required fields");
      return;
    }

    isLoading.value = true;

    String dateStr = dateController.text;
    try {
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(dateStr);
      dateStr = DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      // If parsing fails, fall back to the original text
    }

    Map<String, dynamic> body = {
      'title': titleController.text,
      'type': selectedRouteType.value?.name ?? '',
      'description': descriptionController.text,
      'address': addressController.text,
      'date': dateStr,
      'max_participants': maxParticipantsController.text,
      // 'route': 'sport', // Optional as per image description
    };

    List<MultipartBody> images =
        selectedImages.map((file) => MultipartBody('image', file)).toList();

    bool success = await _repository.createActivity(
      body: body,
      images: images,
    );

    isLoading.value = false;

    if (success) {
      Get.back();
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    dateController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    maxParticipantsController.dispose();
    super.onClose();
  }
}
