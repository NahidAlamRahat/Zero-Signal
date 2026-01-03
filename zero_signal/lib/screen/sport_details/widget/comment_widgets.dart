import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/routes/app_routes.dart';
import 'package:zero_signal/screen/sport_details/controller/sport_details_controller.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> comment;

  const CommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: comment['avatar'],
                backgroundImage: (comment['imageUrl'] != null &&
                        comment['imageUrl'].isNotEmpty)
                    ? NetworkImage(comment['imageUrl'])
                    : null,
                child:
                    (comment['imageUrl'] == null || comment['imageUrl'].isEmpty)
                        ? Icon(
                            comment['avatarIcon'],
                            color: comment['avatarIconColor'],
                            size: 20,
                          )
                        : null,
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: comment['name'],
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontColor: AppColor.textColor,
                  ),
                  TextWidget(
                    text: comment['date'],
                    fontColor: AppColor.subTitleColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          TextWidget(
            text: comment['comment'],
            fontWeight: FontWeight.w400,
            fontSize: 14,
            fontColor: AppColor.subTitleColor,
            textAlignment: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

class CommentsSection extends StatelessWidget {
  final SportDetailsController controller;

  const CommentsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: AppStrings.commentsHeader,
                  fontColor: AppColor.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  textAlignment: TextAlign.left,
                ),
                GestureDetector(
                  onTap: () => controller.toggleComments(),
                  child: TextWidget(
                    text: controller.showAllComments.value
                        ? AppStrings.showLess
                        : '${AppStrings.seeMore} (${controller.remainingCommentsCount})',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontColor: AppColor.backgroundColor,
                    underline: true,
                  ),
                ),
              ],
            ),
            ...controller.displayedComments
                .map((comment) => CommentItem(comment: comment)),
            AddCommentSection(),
          ],
        ));
  }
}

class AddCommentSection extends StatelessWidget {
  const AddCommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SportDetailsController>();
    return SafeArea(
      child: Column(
        children: [
          TextFieldWidget(
            controller: controller.commentController,
            maxLines: 3,
            minLines: 3,
            borderColor: AppColor.lightGrayishOrange,
            backgroundColor: AppColor.lightGrayishOrange,
            borderRadius: 8,
            hintText: AppStrings.addCommentHint,
            hintStyle: TextStyle(
              color: AppColor.subTitleColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.openSans().fontFamily,
            ),
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Obx(() => ButtonWidget(
                  backgroundColor: AppColor.backgroundColor,
                  label: controller.isPostingComment.value
                      ? AppStrings.posting
                      : AppStrings.commentButton,
                  maxLines: 1,
                  buttonWidth: 130.w,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  buttonHeight: 40,
                  onPressed: controller.isPostingComment.value
                      ? () {}
                      : () => controller.postComment(),
                )),
          ),
          SizedBox(height: 10),
          Center(
            child: InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.updateInformationScreen);
              },
              child: TextWidget(
                text: AppStrings.updateStatus,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontColor: AppColor.backgroundColor,
                underline: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
