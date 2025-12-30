import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/utils/extension.dart';

class SpotInfo extends StatelessWidget {
  final String name;
  final String uploadDate;

  const SpotInfo({
    Key? key,
    required this.name,
    required this.uploadDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
              color: const Color(0xFF2C2C2C),
              fontSize: 16.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),

          Text(
            'Uploaded on ${DateTime.tryParse(uploadDate)?.date}',
            style: TextStyle(
              color: const Color(0xFF565656),
              fontSize: 14.sp,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}