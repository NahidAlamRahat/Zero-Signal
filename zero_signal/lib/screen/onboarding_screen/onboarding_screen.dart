import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/utils/app_size.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 244, 233, 1),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: AppSize.height(value: 250)),
            Image.asset(
              AppImagePath.appLogo,
              height: AppSize.width(value: 160),
              width: AppSize.width(value: 390),
            ),

            TextWidget(text: '')

                     ],
        ),
      ),
    );
  }
}
