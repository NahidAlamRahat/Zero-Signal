import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

enum ActionsLayout { row, column }

class ShowCustomDialog extends StatelessWidget {
  final IconData? icon;
  final double iconSize;
  final Color iconColor;

  final Widget? image;

  final String? title;
  final TextStyle? titleStyle;

  final String? description;
  final TextStyle? descriptionStyle;

  final String buttonText;
  final Color buttonColor;
  final TextStyle? buttonTextStyle;

  final double borderRadius;
  final Color backgroundColor;

  // ✅ Extra buttons
  final List<Widget>? actions;
  final ActionsLayout actionsLayout;

  final double titleDescriptionSpacing;
  final double topPadding;
  final double leftPadding;
  final double rightPadding;
  final double bottomPadding;

  // ✅ Control icon/image
  final bool showIcon;

  // ✅ Actions alignment
  final MainAxisAlignment actionsAlignment;

  // ✅ Title alignment
  final TextAlign titleAlignment;

  // ✅ Description alignment
  final TextAlign descriptionAlignment;

  const ShowCustomDialog({
    super.key,
    this.topPadding = 40,
    this.leftPadding = 16,
    this.rightPadding = 16,
    this.bottomPadding = 16,
    this.icon,
    this.iconSize = 90,
    this.iconColor = Colors.black87,
    this.image,
    this.title,
    this.titleStyle,
    this.description,
    this.descriptionStyle,
    this.buttonText = "Done",
    this.buttonColor = Colors.green,
    this.buttonTextStyle,
    this.borderRadius = 16,
    this.backgroundColor = Colors.white,
    this.actions,
    this.actionsLayout = ActionsLayout.row,
    this.titleDescriptionSpacing = 12,
    this.showIcon = true,
    this.actionsAlignment = MainAxisAlignment.center,
    this.titleAlignment = TextAlign.center,
    this.descriptionAlignment = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(

              left: leftPadding.w,
              right: rightPadding.w,
              bottom: borderRadius.h,
              top: topPadding.h,),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✅ Icon/Image only if enabled
                if (showIcon)
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: image ??
                        Icon(
                          icon,
                          size: iconSize,
                          color: iconColor,
                        ),
                  ),

                // ✅ Title
                if (title != null && title!.isNotEmpty)
                  TextWidget(
                   text:  title!,

                    fontColor: titleStyle?.color ?? AppColor.textColor,
                    fontSize: titleStyle?.fontSize ?? 20,
                    fontWeight: titleStyle?.fontWeight ?? FontWeight.w600,
                    textAlignment: titleAlignment,
                  ),

                // ✅ Description
                if (description != null && description!.isNotEmpty)
                  TextWidget(
                   text:  description!,
                    maxLines: 2,

                    fontColor: descriptionStyle?.color ?? AppColor.textColor,
                    fontSize: descriptionStyle?.fontSize ?? 14,
                    fontWeight: descriptionStyle?.fontWeight ?? FontWeight.w400,
                    textAlignment: descriptionAlignment,
                  ),

                 SizedBox(height: 16.h),

                // ✅ Actions
                if (actions != null && actions!.isNotEmpty) ...[
                  actionsLayout == ActionsLayout.row
                      ? Row(
                    mainAxisAlignment:
                    actionsAlignment, // Row এ horizontal alignment
                    children: actions!
                        .map(
                          (btn) => btn,
                    )
                        .toList(),
                  )
                      : Column(
                    crossAxisAlignment:
                    actionsAlignment == MainAxisAlignment.start
                        ? CrossAxisAlignment.start
                        : actionsAlignment ==
                        MainAxisAlignment.end
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.center, // ✅ Column এ vertical alignment
                    children: actions!
                        .map(
                          (btn) => btn,
                    )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),

          // ✅ Close button
          Positioned(
            right: 20,
            top: 20,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
