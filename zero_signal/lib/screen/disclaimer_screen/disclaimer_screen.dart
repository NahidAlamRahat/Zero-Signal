
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constant/app_colors.dart';
import '../../widget/appbar_widget/appbar_widget.dart';
import '../../widget/text_widget/text_widgets.dart';
import 'controller/disclaimer_controller.dart';


class DisclaimerScreen extends StatelessWidget {
  DisclaimerScreen({super.key});

  final DisclaimerController controller = Get.put(
    DisclaimerController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.creamBackgroundColor,
      appBar:  AppbarWidget(
        backgroundColor: AppColor.creamBackgroundColor,
        textWidget: TextWidget(text: controller.args['name'] ,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(16.w),
        child:Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.errorMessage.value,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),

                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Html(
              data: controller.content,
            ),
          );
        }),
      ),
    );
  }
}
