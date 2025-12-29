import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_strings.dart';
import '../controller/profile_controller.dart';

class LogoutAlertDialog extends StatelessWidget {
  final ProfileController controller;

  const LogoutAlertDialog({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFFFF4E9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.all(12),
      content: SizedBox(
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, size: 24),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.logout,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2C2C2C),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.10,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  AppStrings.areYouSureLogout,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF565656),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildButton(
                    label: AppStrings.no,
                    bgColor: Colors.transparent,
                    textColor: const Color(0xFF2E4F3E),
                    borderColor: const Color(0xFF2E4F3E),
                    onTap: () => Get.back(),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildButton(
                    label: AppStrings.yes,
                    bgColor: const Color(0xFF2E4F3E),
                    textColor: const Color(0xFFF1F1F1),
                    onTap: () => controller.logout(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required Color bgColor,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: ShapeDecoration(
        color: bgColor,
        shape: RoundedRectangleBorder(
          side: borderColor != null
              ? BorderSide(width: 1, color: borderColor)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 1.10,
          ),
        ),
      ),
    );
  }
}

void showLogoutDialog({
  required BuildContext context,
  required ProfileController controller,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return LogoutAlertDialog(controller: controller);
    },
  );
}
