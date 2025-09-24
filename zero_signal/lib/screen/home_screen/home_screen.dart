import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_image_path.dart';

import '../button_nav_bar/button_nav_bar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage(AppImagePath.mapImage),
              fit: BoxFit.cover
          )
        ),
      ),
    );
  }
}
