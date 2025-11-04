
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/screen/home_screen/conntroller/home_screen_controller.dart';
import 'package:zero_signal/screen/home_screen/widget/filter_button_sheet.dart';
import 'package:zero_signal/screen/home_screen/widget/map_type_bottom_sheet.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import '../../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
   HomeScreen({super.key});
  final controller = Get.find<HomeScreenController>();


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: _buildAppBarTitle(),
    );
  }

  Widget _buildAppBarTitle() {
    return Row(
      children: [
        Expanded(
          child: TextFieldWidget(
            hintText: 'Search in ZeroSignal',
            fieldHeight: 40,
            borderColor: Colors.transparent,
            prefixIcon: Icon(Icons.search, color: Colors.grey),
          ),
        ),
        const SizedBox(width: 10),
        Image.asset(AppIconPath.downloadIcon, width: 40, height: 40),
        const SizedBox(width: 10),
        _buildFilterButton(),
      ],
    );
  }

  Widget _buildFilterButton() {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (context, scrollController) => const FilterBottomSheet(),
          ),
        );
      },
      child: Image.asset(AppIconPath.filtaringIcon, width: 65, height: 65),
    );
  }

  Widget _buildBody() {
    return GetBuilder<HomeScreenController>(
      builder: (controller) {
        return Stack(
          children: [
            mapbox.MapWidget(onMapCreated: controller.onMapCreated),
            _buildMapTypeButton(),
            _buildBottomActionButtons(),
            if (controller.isLoading)
              Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }

  Widget _buildMapTypeButton() {
    return Positioned(
      top: kToolbarHeight + 50.h,
      right: 20.w,
      child: InkWell(
        onTap: _showMapTypeBottomSheet,
        child: Image.asset(
          AppIconPath.choiceMap,
          width: 40.w,
          height: 40.h,
        ),
      ),
    );
  }

  Widget _buildBottomActionButtons() {
    return Positioned(
      right: 36.w,
      bottom: 100.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCircleButton(
            iconPath: AppIconPath.mapIcon,
            color: AppColor.backgroundColor,
          ),
          const SizedBox(height: 10),
          _buildCircleButton(
            iconPath: AppIconPath.addIcon,
            color: AppColor.blackColor,
            onTap: () => Get.toNamed(AppRoutes.spotDetailsScreen),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required String iconPath,
    required Color color,
    VoidCallback? onTap,
  }) {
    final button = Container(
      height: 47.h,
      width: 47.h,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Image.asset(iconPath, height: 24.h, width: 24.w),
    );

    return onTap != null ? InkWell(onTap: onTap, child: button) : button;
  }

  void _showMapTypeBottomSheet() {
    final controller = Get.find<HomeScreenController>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => MapTypeBottomSheet(
        selectedMapType: controller.selectedMapType,
        onMapTypeSelected: (type) async {
          controller.selectedMapType = type;
          controller.update();
          await controller.updateMapStyle(type);
        },
      ),
    );
  }
}
