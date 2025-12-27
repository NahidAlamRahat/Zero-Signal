import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/repository/report_repository.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';

import '../widget/text_widget/text_widgets.dart';

class ReportActivityBottomSheet extends StatefulWidget {
  final String itemId;
  final String type;

  const ReportActivityBottomSheet({
    super.key,
    required this.itemId,
    required this.type,
  });

  @override
  State<ReportActivityBottomSheet> createState() =>
      _ReportActivityBottomSheetState();
}

class _ReportActivityBottomSheetState extends State<ReportActivityBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final ReportRepository _repository = ReportRepository();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (_controller.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a reason for reporting",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await _repository.reportItem(
      reason: _controller.text.trim(),
      itemId: widget.itemId,
      type: widget.type,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      if (mounted) {
        Navigator.pop(context);
        Get.snackbar(
          "Success",
          "Report submitted successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Failed to submit report. Please try again.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.bGColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    size: 24,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Title
          const TextWidget(
            text: 'Report Activity',
            fontColor: AppColor.textColor,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),

          SizedBox(height: 8.h),

          // Subtitle
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextWidget(
              text:
                  'Please provide details about the issue to help our moderation team.',
              textAlignment: TextAlign.center,
              fontColor: AppColor.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 24),

          // Text field label
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextWidget(
                text: 'Reason for reporting',
                fontColor: AppColor.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          SizedBox(height: 8.h),

          // Text field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _controller,
              maxLines: 4,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'e.g., Inappropriate content, spam, harassment.....',
                hintStyle:
                    TextStyle(fontSize: 12, color: AppColor.subTitleColor),
                filled: true,
                fillColor: AppColor.overLayBoxColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Submit button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: SizedBox(
                width: double.infinity,
                height: 50,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ButtonWidget(
                        label: 'Send to Administration',
                        backgroundColor: AppColor.backgroundColor,
                        onPressed: _submitReport,
                      )),
          ),

          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

// Usage example:
// Usage example:
void showReportBottomSheet(
  BuildContext context, {
  required String itemId,
  required String type,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => SafeArea(
        child: ReportActivityBottomSheet(
      itemId: itemId,
      type: type,
    )),
  );
}
