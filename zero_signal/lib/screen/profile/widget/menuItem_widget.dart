import 'package:flutter/material.dart';

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
    this.titleColor = const Color(0xFF2C2C2C),
    this.iconWidth = 20,
    this.iconHeight = 20,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconWidget(
                  icon: icon,
                  width: iconWidth,
                  height: iconHeight,
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
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.black,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}
