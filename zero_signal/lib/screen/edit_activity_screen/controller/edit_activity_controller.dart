import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zero_signal/repository/activity_repository.dart';
import 'package:zero_signal/screen/list_screen/list_screen.dart';
import 'package:zero_signal/screen/list_screen/model/activity_list_model.dart';

class EditActivityController extends GetxController {
  final ActivityRepository _repository = ActivityRepository();

  TextEditingController descriptionController = TextEditingController();
  TextEditingController participantsController = TextEditingController();

  late ActivityItem activity;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is ActivityItem) {
      activity = Get.arguments as ActivityItem;
      descriptionController.text = activity.description ?? '';
      fetchActivityDetails();
    }
  }

  Future<void> fetchActivityDetails() async {
    isLoading.value = true;
    final details =
        await _repository.getSingleActivity(activityId: activity.id);
    isLoading.value = false;

    if (details != null) {
      descriptionController.text = details.description ?? '';
      participantsController.text = details.maxParticipants?.toString() ?? '';
    }
  }

  Future<void> updateActivity() async {
    if (descriptionController.text.isEmpty) {
      Get.snackbar("Error", "Description is required");
      return;
    }
    if (participantsController.text.isEmpty) {
      Get.snackbar("Error", "Participants count is required");
      return;
    }

    isLoading.value = true;

    Map<String, dynamic> body = {
      "description": descriptionController.text,
      "max_participants": participantsController.text,
    };

    final success = await _repository.updateActivity(
      activityId: activity.id,
      body: body,
    );

    isLoading.value = false;

    if (success) {
      Get.back(); // Go back to list
      // Ideally we should tell list controller to refresh.
      // This might require finding ListScreenController or using a result.
      // For now, let's just go back.
    }
  }
}
