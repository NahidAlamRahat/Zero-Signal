import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

class WebsiteViewScreen extends StatelessWidget {
  const WebsiteViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.creamBackgroundColor,
      ),

      backgroundColor: AppColor.creamBackgroundColor,
      body: Center(child: TextWidget(text: ' http://zero signal',fontColor: Color(0xFF411BEC),),),
    );
  }
}
