import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/widget/glass_container.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImagePath.socialBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Center(child: GlassContainer(height: 500, width: 300))],
          ),
        ),
      ),
    );
  }
}
