import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';

class UpdateInformationScreen extends StatefulWidget {
  const UpdateInformationScreen({super.key});

  @override
  _UpdateInformationScreenState createState() => _UpdateInformationScreenState();
}

class _UpdateInformationScreenState extends State<UpdateInformationScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.creamBackgroundColor, // Light beige background
      appBar: AppBar(
        backgroundColor: AppColor.creamBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Update Information',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modifications label
            Text(
              'Modifications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),

            // Text input area
            TextFieldWidget(
              hintText: 'Enter a description of the changes here....',
              hintStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              controller: _textController,
              borderColor: AppColor.creamBackgroundColor,
              borderRadius: 16,
              minLines: 7,
              maxLines: 8,
              backgroundColor: Color.fromRGBO(245, 233, 223, 1),
            ),

            SizedBox(height: 16),

            // Camera button
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColor.lightGrayishOrange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.camera_alt_outlined, size: 20),
            ),

            // Push everything else to bottom
            Spacer(),

            // Submit button
            Center(
              child: ButtonWidget(
                buttonWidth: double.infinity,
                backgroundColor: AppColor.backgroundColor,
                onPressed: () {
                  // Handle submit button press
                  print("Submitted: ${_textController.text}");
                },
                label: 'Submit for Review',
              ),
            ),
            SizedBox(height: 16),

            // Thank you message
            Center(
              child: Text(
                'Thank you for helping other people like you',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
