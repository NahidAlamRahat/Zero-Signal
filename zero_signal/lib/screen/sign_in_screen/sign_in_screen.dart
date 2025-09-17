import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/screen/sign_in_screen/widget/glass_effact.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(AppImagePath.signInBackgroundImage),
               fit: BoxFit.cover
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GlassEffact(
                    height: 320,
                    child: Column(
                      children: [
                        const SizedBox(height: 20,),
                        Image.asset(AppImagePath.appLogo, width: 61, height: 60,),
                        const SizedBox(height: 20,),

                        TextWidget(text: AppStrings.lifeIsShortAndSignIn,
                        fontColor: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        const SizedBox(height: 20,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          ElevatedButton(
                              onPressed: (){},
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 40),
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
                             side: BorderSide(color: Colors.white)
                              ),
                            ),
                            child: TextWidget(text: "Sign In",
                           fontColor: Colors.white,

                            )
                        ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ButtonWidget(
                            backgroundColor: AppColor.backgroundColor,
                            label: 'Registration',
                            buttonHeight: 40,
                          ),
                        )


                      ],
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
      child: Image.asset(
        AppImagePath.signInBackgroundImage,
        fit: BoxFit.cover,
      ),
    );
  }





}