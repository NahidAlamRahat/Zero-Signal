import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';

import '../widget/text_widget/text_widgets.dart';

class ReportActivityBottomSheet extends StatefulWidget {
  const ReportActivityBottomSheet({super.key});

  @override
  State<ReportActivityBottomSheet> createState() => _ReportActivityBottomSheetState();
}

class _ReportActivityBottomSheetState extends State<ReportActivityBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            // style: TextStyle(
            //   fontSize: 20,
            //   fontWeight: FontWeight.w600,
            //   color: Colors.black,
            // ),
            fontColor: AppColor.textColor,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),

           SizedBox(height: 8.h),

          // Subtitle
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextWidget(
             text:  'Please provide details about the issue to help our moderation team.',
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
               text:  'Reason for reporting',
                // style: TextStyle(
                //   fontSize: 14,
                //   fontWeight: FontWeight.w500,
                //   color: Colors.black,
                // ),
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
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: AppColor.subTitleColor
                ),
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
              child: ButtonWidget(
                label: 'Send to Administration',
                backgroundColor: AppColor.backgroundColor,
                onPressed: () {
                  // Handle submit
                  // if (_controller.text.trim().isNotEmpty) {
                    // Process the report
                    Navigator.pop(context);
                  // }
                },
              )
            ),
          ),

          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

// Usage example:
void showReportBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => SafeArea(child: const ReportActivityBottomSheet()),
  );
}