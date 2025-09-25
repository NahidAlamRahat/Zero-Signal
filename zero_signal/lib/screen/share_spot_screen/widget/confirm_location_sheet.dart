import 'package:flutter/material.dart';

import '../../../constant/app_icon_path.dart';
import '../../../constant/app_image_path.dart';

class ConfirmLocationSheet extends StatelessWidget {
  const ConfirmLocationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Sheet er design
      decoration: const BoxDecoration(
        color: Color(0xFFF0EBE6), // Background color
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Content onujayi choto thakbe
          children: [
            // 1. Header (Title and Close button)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40), // Ektu space rakhar jonno
                const Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Divider(),
            const SizedBox(height: 15),

            // 2. Map Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    AppImagePath.mapImage2,
                    // <-- Shure kore 'assets/map_image.png' name ei image ta add korun
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Image.asset(
                    AppIconPath.myLocationIcon,
                    width: 40,
                    height: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // 3. Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE2DACC),
                        // Button color
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Confirm Location Button
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Confirm location er logic ekhane likhben
                        print('Location Confirmed!');
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D5A3D),
                        // Button color
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Confirm location',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}