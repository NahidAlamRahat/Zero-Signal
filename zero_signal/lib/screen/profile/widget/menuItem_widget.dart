import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant/app_colors.dart';
import '../../../widget/icon_widget/icon_widget.dart';
import '../../../widget/space_widget.dart';
import '../../../widget/text_widget/text_widgets.dart';

class MenuItemWidget extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final Color titleColor;
  final double iconWidth;
  final double iconHeight;

  const MenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.titleColor =AppColor.textColor,
    this.iconWidth = 15,
    this.iconHeight = 15,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconWidget(
                  icon: icon,
                  width: iconWidth.w,
                  height: iconHeight.h,
                ),
                SpaceWidget(spaceWidth: 12),
                TextWidget(
                  text: title,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontColor: titleColor,
                ),
              ],
            ),
             Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.black,
              size: 15.h,
            ),
          ],
        ),
      ),
    );
  }
}
