import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/routes/app_routes.dart';
import 'package:zero_signal/screen/sport_details/controller/sport_details_controller.dart';
import 'package:zero_signal/screen/sport_details/widget/date_picker_sheet.dart';
import 'package:zero_signal/screen/sport_details/widget/user_dialogs.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              showUserDialog(
                context,
                userId: '', // Placeholder
                userName: 'naturanauta',
                userBio: '',
              );
            },
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.brown,
                  child: Icon(
                    Icons.person,
                    size: 16,
                    color: AppColor.white500,
                  ),
                ),
                SizedBox(width: 8),
                TextWidget(
                  text: '@naturanauta',
                ),
              ],
            ),
          ),
        ),
        Icon(
          Icons.star,
          color: AppColor.yello,
          size: 18,
        ),
        TextWidget(
          text: '(17 lugares / 6 plane)',
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ],
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SportDetailsController>();

    return Row(
      children: [
        Expanded(
          child: ButtonWidget(
            backgroundColor: AppColor.backgroundColor,
            label: 'How To Arrive',
            fontSize: 11,
            fontWeight: FontWeight.w400,
            buttonHeight: 33,
            buttonWidth: 120,
            maxLines: 1,
            onPressed: () {
              // Navigate to spot navigation screen with spot data
              Get.toNamed(
                AppRoutes.spotNavigationScreen,
                arguments: {
                  'spotId': controller.spotId.value,
                  'title': controller.spotTitle.value,
                  'latitude': controller.spotLatitude.value,
                  'longitude': controller.spotLongitude.value,
                },
              );
            },
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ButtonWidget(
            backgroundColor: AppColor.overLayBoxColor,
            label: 'Add Favorites',
            buttonWidth: 120,
            fontSize: 11,
            buttonHeight: 33,
            fontWeight: FontWeight.w400,
            textColor: AppColor.textColor,
            onPressed: () {},
            maxLines: 1,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ButtonWidget(
            backgroundColor: Color.fromRGBO(245, 233, 223, 1),
            label: 'Assist',
            buttonHeight: 40,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            maxLines: 1,
            textColor: AppColor.textColor,
            onPressed: () {
              showDatePickerSheet(context);
            },
          ),
        ),
      ],
    );
  }
}

Future<DateTime?> showDatePickerSheet(BuildContext context) async {
  return await showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => SafeArea(
      child: Container(
        width: Get.width,
        color: AppColor.creamBackgroundColor,
        child: const DatePickerSheet(),
      ),
    ),
  );
}
