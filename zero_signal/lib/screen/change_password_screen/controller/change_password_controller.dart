import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../repository/auth_repo/change_pass_repo.dart';
import '../../../utils/app_log/app_log.dart';
import '../../../widget/app_snack_bar/app_snack_bar.dart';
import '../model/change_password_model.dart';

class ChangePasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ChangePasswordRepository _changePasswordRepository =
      Get.put(ChangePasswordRepository());
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Validate Current Password
  String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Current Password";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  // Validate New Password
  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter New Password";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters";
    } else if (value == currentPasswordController.text) {
      return "New password must be different from current password";
    }
    return null;
  }

  // Validate Confirm Password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Confirm your Password";
    } else if (value != newPasswordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  /// On Tap Change Button
  Future<void> onTapChangeButton() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      isLoading.value = true;

      final ChangePasswordModel model = ChangePasswordModel(
        currentPassword: currentPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
      );

      final bool isSuccess =
          await _changePasswordRepository.changePassword(model);

      isLoading.value = false;

      if (isSuccess) {
        AppSnackBar.success(_changePasswordRepository.successfullyMessage ??
            'Password changed successfully!');
        appLog(
            'success message => ${_changePasswordRepository.successfullyMessage}');

        // Clear form fields on success
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        // Navigate back
        Get.back();
      } else {
        AppSnackBar.message('${_changePasswordRepository.errorMessage}');
        appLog('error message => ${_changePasswordRepository.errorMessage}');
      }
    }
  }
}
