import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';

import '../../constant/app_colors.dart';
import '../../widget/text_button_widget/text_button_widget.dart';
import '../button_nav_bar/button_nav_bar_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // image appbar er niche jabe
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Search Box
            Expanded(
            child: TextFieldWidget(
              hintText: 'Search in ZeroSignal',
              fieldHeight: 40,
              prefixIcon: Icon(Icons.search,color: Colors.grey,),
            ),
            ),

            const SizedBox(width: 10),

            // Download Icon
            Image.asset(AppIconPath.downloadIcon,width: 40, height: 40),


            const SizedBox(width: 10),

            // Filtering Icon
            InkWell(
              onTap: (){
// Button এ tap করলে bottom sheet show হবে
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
                child: Image.asset(
                AppIconPath.filtaringIcon,
                width: 65, height: 65)),
          ],
        ),
      ),

      // Map Background
      body: Stack(
        children: [
          // Background Image
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImagePath.mapImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Top-right icon (AppBar এর নিচে)
          Positioned(
            top: kToolbarHeight + 50.h, // AppBar এর height অনুযায়ী নিচে নামাও
            right: 20, // ডান পাশে রাখতে
            child: Image.asset(
              AppIconPath.choiceMap,
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),


      // Floating Buttons (bottom-right)
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.transparent,
            heroTag: "btn2",
            onPressed: () {},
            child: Image.asset(AppIconPath.mapIcon),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            backgroundColor: Colors.transparent,
            heroTag: "btn2",
            onPressed: () {},
            child: Image.asset(AppIconPath.addIcon),
          ),
        ],
      ),
    );
  }
}



class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // Track selected filters
  Set<String> selectedFilters = {};

  // Filter categories and their options
  final Map<String, List<String>> filterCategories = {
    'Nature & Landscape': [
      'View Points',
      'Natural Pool',
      'River',
      'Cove',
      'Waterfall',
      'Monumental Trees',
      'Natural Spring',
      'Swamp',
      'Thermal Water',
    ],
    'Overnight & Rest': [
      'Verified Overnight Area',
      'Wild Rest Area',
      'Hostel',
      'Camper Area',
      'Shelter',
      'Bivouac Area',
      'Picnic Area',
    ],
    'Exploration & Adventure': [
      'Mines',
      'Caves',
      'Hanging Bridges',
      'Tunnels',
      'Hidden Passage',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.creamBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 24),
                  color: Colors.black,
                ),
              ],
            ),
          ),

          // Filter content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Build each category
                  ...filterCategories.entries.map((category) {
                    return _buildFilterCategory(
                      category.key,
                      category.value,
                    );
                  }).toList(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [

                Expanded(
                  child: ButtonWidget(
                      buttonWidth: 10,
                      backgroundColor: Colors.transparent,
                      label: "Clear All",
                      buttonHeight: 48,
                      textColor: AppColor.yello,
                      onPressed: () {
                        setState(() {
                          selectedFilters.clear();
                        });
                      }
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: ButtonWidget(
                    buttonWidth: 10,
                    backgroundColor: AppColor.backgroundColor,
                    label: "Show Results",
                    buttonHeight: 48,
                    textColor: Colors.white,
                    onPressed: () {
                      // Handle show results
                      Navigator.pop(context, selectedFilters);
                    }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCategory(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedFilters.contains(option);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedFilters.remove(option);
                  } else {
                    selectedFilters.add(option);
                  }
                });
              },
              child: Material(
                elevation: isSelected ? 4.0 : 4.0, // Different elevation for selected/unselected
                borderRadius: BorderRadius.circular(20),
                shadowColor: Colors.black26,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.backgroundColor
                        : AppColor.creamBackgroundColor,
                    border: Border.all(
                      color: isSelected
                          ? AppColor.backgroundColor
                          : Color(0xFFD6C8B0),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}