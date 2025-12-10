import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppSnackBar {
  static error(String message, {int seconds = 2}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: seconds > 3 ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: seconds,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static success(String message, {int seconds = 2}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: seconds > 3 ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: seconds,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static message(
    String message, {
    Color backgroundColor = Colors.grey,
    Color color = Colors.white,
    int seconds = 2,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: seconds > 3 ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: seconds,
      backgroundColor: backgroundColor,
      textColor: color,
      fontSize: 16.0,
    );
  }
}
