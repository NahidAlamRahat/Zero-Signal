import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_image_path.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Liam Johnson');
  final TextEditingController _oneSentenceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController(
      text: 'Lam loves to explore new places and experience different cultures. Her heart beats for the thrill of adventure. She finds joy in every journey, whether it\'s wandering through ancient ruins, hiking up a mountain, or simply getting lost in a new city.'
  );
  final TextEditingController _emailController = TextEditingController(text: 'hola@zerosignal.app');
  final TextEditingController _genderController = TextEditingController(text: 'Male');
  final TextEditingController _dobController = TextEditingController(text: '17 dec, 2024');
  final TextEditingController _addressController = TextEditingController(text: '297 Westheimer Rd. Santa Ana');

  @override
  void dispose() {
    _nameController.dispose();
    _oneSentenceController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }

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
                padding: const EdgeInsets.all(20),
                child: Column(
                  spacing: 20,
                  children: [
                    // Profile Image
                    _buildProfileImage(),

                    // Form Fields
                    _buildFormFields(),

                    // Save Button
                    _buildSaveButton(),
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
              'Edit Profile',
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

  Widget _buildProfileImage() {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: const Color(0xFF484949), width: 3),
            image: const DecorationImage(
              image: AssetImage(AppImagePath.profileImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              // Handle image edit
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF2E4F3E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.edit,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      spacing: 16,
      children: [
        _buildTextField('Full Name', _nameController),
        _buildTextField('Me in one sentence', _oneSentenceController),
        _buildTextField(
          'Description',
          _descriptionController,
          maxLines: 4,
          height: 100,
        ),
        _buildTextField('Email', _emailController),
        _buildDropdownField('Gender', _genderController, ['Male', 'Female', 'Other']),
        _buildDateField('Date of birth', _dobController),
        _buildTextField('Address', _addressController),
      ],
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        int maxLines = 1,
        double? height,
      }) {
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
          height: height ?? 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF5E9DF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(
              color: Color(0xFF2C2C2C),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: Color(0xFF999999),
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, TextEditingController controller, List<String> options) {
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
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF5E9DF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: controller.text.isNotEmpty ? controller.text : null,
            style: const TextStyle(
              color: Color(0xFF2C2C2C),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: InputBorder.none,
            ),
            dropdownColor: const Color(0xFFF5E9DF),
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                controller.text = newValue ?? '';
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
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
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              controller.text = "${picked.day} ${_getMonthName(picked.month)}, ${picked.year}";
              setState(() {});
            }
          },
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF5E9DF),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    controller.text.isNotEmpty ? controller.text : 'Select date',
                    style: TextStyle(
                      color: controller.text.isNotEmpty ? const Color(0xFF2C2C2C) : const Color(0xFF999999),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF2C2C2C),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: () {
          // Handle save action
          _saveProfile();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E4F3E),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Save & Continue',
          style: TextStyle(
            color: Color(0xFFF1F1F1),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    // Handle profile saving logic here
    print('Name: ${_nameController.text}');
    print('One sentence: ${_oneSentenceController.text}');
    print('Description: ${_descriptionController.text}');
    print('Email: ${_emailController.text}');
    print('Gender: ${_genderController.text}');
    print('DOB: ${_dobController.text}');
    print('Address: ${_addressController.text}');

    // Show success message or navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Color(0xFF2E4F3E),
      ),
    );
  }
}