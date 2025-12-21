import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constant/app_colors.dart';
import '../../../gen/assets.gen.dart';
import '../../favorite_sites_screen/favorite_sites_screen.dart';
import '../model/my_spots_response_model.dart';

class SpotActions extends StatelessWidget {
  final SpotData spot;
  final VoidCallback onFavoriteTap;
  final VoidCallback onDeleteTap;

  const SpotActions({
    Key? key,
    required this.spot,
    required this.onFavoriteTap,
    required this.onDeleteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onFavoriteTap,
            child: Icon(
              spot.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: spot.isFavorite ? AppColor.red : const Color(0xFF999999),
              size: 18.sp,
            ),
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: onDeleteTap,
            child: Image.asset(
              Assets.icons.deleteIcon.path,
              width: 12,
              height: 12,
            ),
          ),
        ],
      ),
    );
  }
}
