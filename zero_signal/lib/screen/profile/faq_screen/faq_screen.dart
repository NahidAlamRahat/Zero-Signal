import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zero_signal/screen/profile/faq_screen/widgets/faq_item.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_strings.dart';
import '../../../utils/capitalize.dart';
import '../../../widget/appbar_widget/appbar_widget.dart';

import 'controller/faq_screen_controller.dart';

class FAQScreen extends StatelessWidget {
  FAQScreen({super.key});
  final FAQScreenController controller = Get.find<FAQScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.creamBackgroundColor,
      appBar: AppbarWidget(
        backgroundColor: AppColor.creamBackgroundColor,
        text: AppStrings.faq,
        centerTitle: true,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.faqs.isEmpty) {
          return const Center(
            child: Text(
              'No FAQs available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.faqs.length,
          itemBuilder: (context, index) {
            final faq = controller.faqs[index];
            return FAQItem(
              question:
                  "${index + 1}. ${capitalize(faq.answer ?? "No question available")}",
              answer: capitalize(faq.question ?? "No answer available"),
            );
          },
        );
      }),
    );
  }
}
