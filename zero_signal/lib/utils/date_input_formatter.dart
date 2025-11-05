import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    // Remove all non-digit characters for processing
    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');
    
    // If user is deleting, allow it
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }
    
    // Build formatted text
    final buffer = StringBuffer();
    
    for (int i = 0; i < digitsOnly.length; i++) {
      // Add "/" after day (2 digits)
      if (i == 2 || i == 4) {
        buffer.write('/');
      }
      // Maximum 8 digits (ddmmyyyy)
      if (i < 8) {
        buffer.write(digitsOnly[i]);
      }
    }
    
    final formatted = buffer.toString();
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
