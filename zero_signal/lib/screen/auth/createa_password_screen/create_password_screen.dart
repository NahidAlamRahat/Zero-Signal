import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/screen/auth/createa_password_screen/widget/button_sheet.dart';
import 'package:zero_signal/widget/glass_effact.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/space_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../../gen/assets.gen.dart';
import '../../../widget/text_field_widget/text_field_widget.dart';

class CreatePasswordScreen extends StatelessWidget {
  const CreatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImagePath.authBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal:20.0.w),
              child: Center(
                child: GlassEffact(
                //  height: 480.h,
                  width: 390.w,
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Center(child: Image.asset(AppImagePath.appLogo, width: 61, height: 60)),
                        const SizedBox(height: 16),

                        Center(
                          child: TextWidget(
                            text: AppStrings.createPassword,
                            fontColor: AppColor.white500,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Center(
                          child: TextWidget(
                            text: AppStrings.yourNewPassword,
                            fontColor: AppColor.white500,
                            fontSize: 16,
                            maxLines: 2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 20),

                        TextWidget(
                          textAlignment: TextAlign.left,
                          text: AppStrings.newPassword,
                          fontColor: AppColor.white500,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),

                         SizedBox(height: 8.h),


                        TextFieldWidget(
                          textColor: Colors.white,
                          hintText: AppStrings.enterNewPassword,
                          hintColor: Colors.white54,
                          backgroundColor: Colors.transparent,
                          borderColor: Colors.white,
                          focusedBorderColor: Colors.white,
                          borderRadius: 8,
                          borderWidth: 1.0,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        SizedBox(height: 20.w,),

                        TextWidget(
                          textAlignment: TextAlign.left,
                          text: AppStrings.confirmPassword,
                          fontColor: AppColor.white500,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),

                        SizedBox(height: 8.h),

                        // Email TextField
                        TextFieldWidget(
                          textColor: Colors.white,
                          hintText: AppStrings.enterNewPassword,
                          hintColor: Colors.white54,
                          backgroundColor: Colors.transparent,
                          borderColor: Colors.white,
                          focusedBorderColor: Colors.white,
                          borderRadius: 8,
                          borderWidth: 1.0,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        SpaceWidget(spaceHeight: 44,),
                        ButtonWidget(
                          onPressed: (){
                            showPasswordChangedSheet(context);
                          },
                          buttonWidth: double.infinity,
                          backgroundColor: AppColor.backgroundColor,
                          label: AppStrings.save,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// Background image widget
  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(AppImagePath.signInBackgroundImage, fit: BoxFit.cover),
    );
  }
}
