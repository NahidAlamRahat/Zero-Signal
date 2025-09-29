import 'package:flutter/material.dart';

class ReportActivityBottomSheet extends StatefulWidget {
  const ReportActivityBottomSheet({Key? key}) : super(key: key);

  @override
  State<ReportActivityBottomSheet> createState() => _ReportActivityBottomSheetState();
}

class _ReportActivityBottomSheetState extends State<ReportActivityBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5EFE7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    size: 24,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Title
          const Text(
            'Report Activity',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 12),

          // Subtitle
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Please provide details about the issue to help our moderation team.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Text field label
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Reason for reporting',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Text field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: TextField(
              controller: _controller,
              maxLines: 6,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'e.g., Inappropriate content, spam, harassment.....',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                filled: true,
                fillColor: const Color(0xFFE8DCC8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Submit button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit
                  if (_controller.text.trim().isNotEmpty) {
                    // Process the report
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C5F4F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Send to Administration',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

// Usage example:
void showReportBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const ReportActivityBottomSheet(),
  );
}