import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_image_path.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Content
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  spacing: 16,
                  children: [
                    // Profile Card
                    _buildProfileCard(),

                    // Bio Card
                    _buildBioCard(),

                    // Information Form
                    _buildInformationForm(),
                  ],
                ),
              ),
            ],
          ),
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
              // Handle back navigation
            },
            child: const Icon(
              Icons.arrow_back,
              size: 24,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const Expanded(
            child: Text(
              'Personal Information',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF2C2C2C),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 24), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E9DF),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0x23000000),
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color(0xFFFFCB20), width: 2),
              image: const DecorationImage(
                image: AssetImage(AppImagePath.profileImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                const Text(
                  'Liam Johnson',
                  style: TextStyle(
                    color: Color(0xFF2C2C2C),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'hola@zerosignal.app',
                  style: TextStyle(
                    color: Color(0xFFABABAB),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Edit Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0x262E4F3E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Edit Profile',
              style: TextStyle(
                color: Color(0xFF2E4F3E),
                fontSize: 9,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBioCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E9DF),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0x23000000),
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: const Text(
        'Lam loves to explore new places and experience different cultures. Her heart beats for the thrill of adventure. She finds joy in every journey, whether it\'s wandering through ancient ruins, hiking up a mountain, or simply getting lost in a new city.',
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 12,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w400,
          height: 1.48,
        ),
      ),
    );
  }

  Widget _buildInformationForm() {
    return Column(
      spacing: 16,
      children: [
        _buildInfoField('Full Name', 'Liam Johnson'),
        _buildInfoField('Email', 'hola@zerosignal.app'),
        _buildInfoField('Gender', 'Male'),
        _buildInfoField('Date of birth', '17 dec, 2024'),
        _buildInfoField('Address', '297 Westheimer Rd. Santa Ana'),
      ],
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF2C2C2C),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5E9DF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF2C2C2C),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}