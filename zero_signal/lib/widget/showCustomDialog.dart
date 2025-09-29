import 'package:flutter/material.dart';

enum ActionsLayout { row, column }

class ShowCustomDialog extends StatelessWidget {
  final IconData? icon;
  final double iconSize;
  final Color iconColor;

  // ✅ নতুন property → icon এর জায়গায় চাইলে image ব্যবহার করা যাবে
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

  // ✅ title আর description এর মধ্যে gap control করার জন্য
  final double titleDescriptionSpacing;

  const ShowCustomDialog({
    super.key,
    this.icon ,
    this.iconSize = 90,
    this.iconColor = Colors.black87,
    this.image, // ✅ নতুন যোগ হলো
    this.title ,
    this.titleStyle,
    this.description,
    this.descriptionStyle,
    this.buttonText = "Done",
    this.buttonColor = Colors.green,
    this.buttonTextStyle,
    this.borderRadius = 16,
    this.backgroundColor =  Colors.white,
    this.actions,
    this.actionsLayout = ActionsLayout.row, // 🔥 Default Row
    this.titleDescriptionSpacing = 12, // 🔥 Default 12px
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ প্রথমে image check করবে, না থাকলে icon দেখাবে
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


            // Title
            Text(
              title ?? '',
              style: titleStyle ??
                  const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
              textAlign: TextAlign.center,
            ),

            // ✅ spacing only if description is not null or empty
            if (description != null && description!.isNotEmpty)
              SizedBox(height: titleDescriptionSpacing),

            // Description
            if (description != null && description!.isNotEmpty)
              Text(
                description!,
                style: descriptionStyle ??
                    const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 24),

            if (actions != null && actions!.isNotEmpty) ...[
              actionsLayout == ActionsLayout.row
                  ? Row(
                children: actions!
                    .map((btn) => Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: btn,
                  ),
                ))
                    .toList(),
              )
                  : Column(
                children: actions!
                    .map((btn) => Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 4.0),
                  child: btn,
                ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}