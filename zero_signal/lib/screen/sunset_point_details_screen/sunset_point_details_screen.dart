import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_image_path.dart';

class SunsetPointDetailsScreen extends StatefulWidget {
  const SunsetPointDetailsScreen({super.key});

  @override
  State<SunsetPointDetailsScreen> createState() => _SunsetPointDetailsScreenState();
}

class _SunsetPointDetailsScreenState extends State<SunsetPointDetailsScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E9),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero Image
                    _buildHeroImage(),

                    // Details Section
                    _buildDetailsSection(),
                  ],
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              size: 24,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const Expanded(
            child: Text(
              'Sunset Point Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF2C2C2C),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 219,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(AppImagePath.sunImage),
          fit: BoxFit.cover,
        ),
      ),

    );
  }

  Widget _buildDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          // Title and Location
          _buildTitleSection(),


          // Description
          _buildDescriptionSection(),


        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        const Text(
          'Sunset Point',
          style: TextStyle(
            color: Color(0xFF2C2C2C),
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            const Icon(
              Icons.location_on,
              size: 16,
              color: Colors.red,
            ),
            const SizedBox(width: 4),
            const Text(
              'Espot, Catalonia',
              style: TextStyle(
                color: Color(0xFF727272),
                fontSize: 14,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatItem(Icons.visibility, '127', 'Views'),
        const SizedBox(width: 24),
        _buildStatItem(Icons.calendar_today, 'Aug 15', 'Added'),
        const SizedBox(width: 24),
        _buildStatItem(Icons.star, '4.8', 'Rating'),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF2E4F3E),
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF2C2C2C),
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF727272),
                fontSize: 12,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            color: Color(0xFF2C2C2C),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const Text(
          'Escape the heat at the Azure Oasis. This stunning, crystal-clear pool is a tranquil paradise, surrounded by lush greenery. It\'s the perfect spot to relax, refresh, and immerse yourself in serene beauty.',
          style: TextStyle(
            color: Color(0xFF727272),
            fontSize: 16,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w400,
            height: 1.48,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        const Text(
          'Details',
          style: TextStyle(
            color: Color(0xFF2C2C2C),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),

        _buildInfoRow('Best time to visit', 'Golden hour (6-7 PM)'),
        _buildInfoRow('Accessibility', 'Easy walk, 10 minutes'),
        _buildInfoRow('Facilities', 'Parking, Restrooms'),
        _buildInfoRow('Entry fee', 'Free'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF727272),
                fontSize: 14,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF2C2C2C),
                fontSize: 14,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _showFavoriteMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            isFavorite
                ? 'Added to favorites'
                : 'Removed from favorites'
        ),
        backgroundColor: const Color(0xFF2E4F3E),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing Sunset Point...'),
        backgroundColor: Color(0xFF2E4F3E),
      ),
    );
  }

  void _getDirections() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening directions...'),
        backgroundColor: Color(0xFF2E4F3E),
      ),
    );
  }

  void _editSpot() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening edit mode...'),
        backgroundColor: Color(0xFF2E4F3E),
      ),
    );
  }
}