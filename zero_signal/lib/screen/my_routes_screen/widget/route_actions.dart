import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constant/app_colors.dart';
import '../../../gen/assets.gen.dart';
import '../model/route_model.dart';
// Note: Assuming 'isFavorite' logic exists or will be handled.
// Since RouteData doesn't explicitly have isFavorite in the JSON provided (it has type, etc),
// I will assume for now it's not in the model but might be needed.
// I will check if I should add it to the model or handle it side-by-side.
// The provided JSON didn't show 'isFavorite'.
// I will assume false for now or check if it needs to be added to model extension.
// SpotItem had isFavorite. RouteData doesn't seem to based on JSON.
// I will assume it's NOT favorite by default or I need to handle logic.
// I will assume the backend might return it or client manages it.
// For UI, I'll use a placeholder logic.

class RouteActions extends StatelessWidget {
  final RouteData route;
  final VoidCallback onFavoriteTap;
  final VoidCallback onDeleteTap;

  const RouteActions({
    Key? key,
    required this.route,
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
              Icons
                  .favorite_border, // Defaulting to border as JSON didn't have isFavorite
              color: const Color(0xFF999999),
              size: 18.sp,
            ),
          ),
          SizedBox(height: 18.h),
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
