import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../widget/space_widget.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.creamBackgroundColor,

      appBar: AppbarWidget(
        backgroundColor: AppColor.creamBackgroundColor,
        centerTitle: true,
        text: 'Change password' ,
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 8,right: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            SpaceWidget(spaceHeight: 16),
            TextWidget(text: 'Change password',
            fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            SpaceWidget(spaceHeight: 8),

            TextFieldWidget(
              textColor: AppColor.subTitleColor,
              borderColor: AppColor.lightGrayishOrange,
              borderRadius: 8,
              hintText: 'Current Password',
              backgroundColor: AppColor.lightGrayishOrange,
               suffixIcon: true,
            ),


            SpaceWidget(spaceHeight: 16),
            TextWidget(text: 'New Password',
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            SpaceWidget(spaceHeight: 8),

            TextFieldWidget(
              textColor: AppColor.subTitleColor,
              borderColor: AppColor.lightGrayishOrange,
              borderRadius: 8,
              hintText: 'New Password',
              backgroundColor: AppColor.lightGrayishOrange,
              suffixIcon: true,
            ),




            SpaceWidget(spaceHeight: 16),
            TextWidget(text: 'Confirm Password',
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            SpaceWidget(spaceHeight: 8),

            TextFieldWidget(
              textColor: AppColor.subTitleColor,
              borderColor: AppColor.lightGrayishOrange,
              borderRadius: 8,
              hintText: 'Confirm Password',
              backgroundColor: AppColor.lightGrayishOrange,
              suffixIcon: true,
            )








          ],
        ),
      ),

    );
  }
}
