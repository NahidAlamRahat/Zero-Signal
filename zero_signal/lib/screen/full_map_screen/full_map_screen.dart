import 'package:flutter/material.dart';

import '../../constant/app_image_path.dart';

class FullMapScreen extends StatefulWidget {
  const FullMapScreen({super.key});

  @override
  State<FullMapScreen> createState() => _FullMapScreenState();
}

class _FullMapScreenState extends State<FullMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImagePath.mapImage3),
            fit: BoxFit.cover,
          ),
        ),
        child: SizedBox(),
      ),
    );
  }
}
