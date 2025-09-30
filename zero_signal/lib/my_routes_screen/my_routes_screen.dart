import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

class MyRoutesScreen extends StatefulWidget {
  const MyRoutesScreen({super.key});

  @override
  State<MyRoutesScreen> createState() => _MyRoutesScreenState();
}

class _MyRoutesScreenState extends State<MyRoutesScreen> {
  final List<SpotItem> spots = [
    SpotItem(
      id: '1',
      name: 'Sunset Point',
      uploadDate: '2025-08-15',
      imageUrl: AppIconPath.ukFlag,
    ),
    SpotItem(
      id: '2',
      name: 'Mountain Trailhead',
      uploadDate: '2025-08-15',
      imageUrl: AppIconPath.ukFlag,
    ),
    SpotItem(
      id: '3',
      name: 'Beach Cove',
      uploadDate: '2025-08-15',
      imageUrl: AppIconPath.ukFlag,
    ),
    SpotItem(
      id: '4',
      name: 'Forest Clearing',
      uploadDate: '2025-08-15',
      imageUrl: AppIconPath.ukFlag,
    ),
    SpotItem(
      id: '5',
      name: 'River Bend',
      uploadDate: '2025-08-15',
      imageUrl: AppIconPath.ukFlag,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 12 base
      builder: (context, child) {
        return Scaffold(
          appBar: AppbarWidget(
            textWidget:  TextWidget(text: 'My Routes'),
          ),
          backgroundColor: const Color(0xFFFFF4E9),
          body: SafeArea(
            child: Column(
              children: [
                // Header

                // Spots List
                Expanded(
                  child: _buildSpotsList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildSpotsList() {
    if (spots.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: spots.length,
      itemBuilder: (context, index) {
        final spot = spots[index];
        return _buildSpotCard(spot);
      },
    );
  }

  Widget _buildSpotCard(SpotItem spot) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      height: 72.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5E9DF),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: InkWell(
        onTap: () => _onSpotTap(spot),
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              // Spot Image
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    image: AssetImage(spot.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              // Spot Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      spot.name,
                      style: TextStyle(
                        color: const Color(0xFF2C2C2C),
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Uploaded on ${_formatDate(spot.uploadDate)}',
                      style: TextStyle(
                        color: const Color(0xFF565656),
                        fontSize: 14.sp,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Action Icons
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => _toggleFavorite(spot),
                    child: Container(
                      child: Icon(
                        spot.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: spot.isFavorite
                            ? Colors.red
                            : const Color(0xFF999999),
                        size: 20.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 9.h,),
                  GestureDetector(
                    onTap: () => _deleteSpot(spot),
                    child: Container(
                      child: Icon(
                        Icons.delete_outline,
                        color: const Color(0xFFFF6B6B),
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 64.sp,
              color: const Color(0xFF999999),
            ),
            SizedBox(height: 16.h),
            Text(
              'No spots yet',
              style: TextStyle(
                color: const Color(0xFF2C2C2C),
                fontSize: 20.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Start exploring and add your favorite spots',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF565656),
                fontSize: 14.sp,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _addNewSpot,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E4F3E),
                padding: EdgeInsets.symmetric(
                    horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Add Your First Spot',
                style: TextStyle(
                  color: const Color(0xFFF1F1F1),
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSpotTap(SpotItem spot) {
    print('Tapped on spot: ${spot.name}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${spot.name}'),
        backgroundColor: const Color(0xFF2E4F3E),
      ),
    );
  }

  void _toggleFavorite(SpotItem spot) {
    setState(() {
      spot.isFavorite = !spot.isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          spot.isFavorite
              ? '${spot.name} added to favorites'
              : '${spot.name} removed from favorites',
        ),
        backgroundColor: const Color(0xFF2E4F3E),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteSpot(SpotItem spot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Spot'),
          content: Text('Are you sure you want to delete "${spot.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  spots.removeWhere((s) => s.id == spot.id);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${spot.name} deleted'),
                    backgroundColor: const Color(0xFF2E4F3E),
                  ),
                );
              },
              child:
              const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _addNewSpot() {
    print('Add new spot tapped');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add new spot feature coming soon!'),
        backgroundColor: Color(0xFF2E4F3E),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

class SpotItem {
  final String id;
  final String name;
  final String uploadDate;
  final String imageUrl;
  bool isFavorite;

  SpotItem({
    required this.id,
    required this.name,
    required this.uploadDate,
    required this.imageUrl,
    this.isFavorite = false,
  });
}
