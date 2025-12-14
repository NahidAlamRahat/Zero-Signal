import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? text;
  final Widget? textWidget;

  final Widget? action;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle; // Add centerTitle property
  final Color? backgroundColor;
  final Widget? leading;
  final bool showLeading;

  const AppbarWidget({
    super.key,
     this.text,
    this.textWidget,
    this.action,
    this.bottom,
    this.centerTitle, // Add centerTitle to constructor
    this.backgroundColor,
    this.leading,
    this.showLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0 ,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: backgroundColor ?? Colors.white, // ✅ এখানেই দাও
      elevation: 0, // transparent দিলে shadow এড়ানোর জন্য
      leading: showLeading
          ? (leading ??
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 20,
            ),
          ))
          : Container(),
      titleSpacing: -4,
      actions: action != null ? [action!] : null,
      title: textWidget ??
          Text(
            text ?? "",
            style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
      bottom: bottom,
      centerTitle: centerTitle,
    );

  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
