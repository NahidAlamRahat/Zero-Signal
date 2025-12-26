import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../repository/auth_repo/create_password_repository.dart';
import '../../../../utils/app_log/app_log.dart';
import '../../../../widget/app_snack_bar/app_snack_bar.dart';
import '../model/create_password_model.dart';
import '../widget/button_sheet.dart';

class CreatePassController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final CreatePasswordRepository _createPasswordRepository =
      Get.put(CreatePasswordRepository());
  final RxBool isLoading = false.obs;
  String? token;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map) {
      token = Get.arguments['token'];
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Validate New Password
  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter New Password";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters";
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

  /// On Tap Save Button
  Future<void> onTapSaveButton(BuildContext context) async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      isLoading.value = true;

      final CreatePasswordModel model = CreatePasswordModel(
        newPassword: newPasswordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
      );

      final bool isSuccess = await _createPasswordRepository.createPassword(
        model,
        token: token,
      );

      isLoading.value = false;

      if (isSuccess) {
        AppSnackBar.success(_createPasswordRepository.successfullyMessage ??
            'Password created successfully!');
        appLog(
            'success message => ${_createPasswordRepository.successfullyMessage}');

        // Show the password changed bottom sheet as designed
        if (context.mounted) {
          showPasswordChangedSheet(context);
        }
      } else {
        AppSnackBar.message('${_createPasswordRepository.errorMessage}');
        appLog('error message => ${_createPasswordRepository.errorMessage}');
      }
    }
  }
}
