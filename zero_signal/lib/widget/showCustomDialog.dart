import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    this.topPadding = 30,
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
          Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Container(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        title!,
                        style: titleStyle ??
                            const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                        textAlign: titleAlignment,
                      ),
                    ),

                  // ✅ Description
                  if (description != null && description!.isNotEmpty)
                    Text(
                      description!,
                      style: descriptionStyle ??
                          const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            height: 1.4,
                          ),
                      textAlign: descriptionAlignment,
                    ),

                  const SizedBox(height: 24),

                  // ✅ Actions
                  if (actions != null && actions!.isNotEmpty) ...[
                    actionsLayout == ActionsLayout.row
                        ? Row(
                      mainAxisAlignment:
                      actionsAlignment, // Row এ horizontal alignment
                      children: actions!
                          .map(
                            (btn) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0),
                          child: btn,
                        ),
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
                            (btn) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0),
                          child: btn,
                        ),
                      )
                          .toList(),
                    ),
                  ],
                ],
              ),
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
