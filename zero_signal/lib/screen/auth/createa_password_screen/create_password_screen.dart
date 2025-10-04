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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: GlassEffact(
              height: 480.h,
              width: 390.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(child: Image.asset(AppImagePath.appLogo, width: 61, height: 60)),
                  const SizedBox(height: 16),

                  Center(
                    child: TextWidget(
                      text: AppStrings.createPassword,
                      fontColor: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Center(
                    child: TextWidget(
                      text: AppStrings.yourNewPassword,
                      fontColor: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: TextWidget(
                      textAlignment: TextAlign.left,
                      text: AppStrings.newPassword,
                      fontColor: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 12,right: 12),
                    child: TextFieldWidget(
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
                  ),

                  SizedBox(height: 20.w,),

                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: TextWidget(
                      textAlignment: TextAlign.left,
                      text: AppStrings.confirmPassword,
                      fontColor: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // Email TextField
                  Padding(
                    padding: const EdgeInsets.only(left: 12,right: 12),
                    child: TextFieldWidget(
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
                  ),

                  SpaceWidget(spaceHeight: 44,),

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: ButtonWidget(
                        onPressed: (){
                          showPasswordChangedSheet(context);
                        },
                        buttonWidth: double.infinity,
                        backgroundColor: AppColor.backgroundColor,
                        label: AppStrings.save,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
