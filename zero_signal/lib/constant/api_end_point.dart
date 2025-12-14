import 'package:flutter/foundation.dart';

import '../utils/app_log/error_log.dart';

class AppApiEndPoint {
  AppApiEndPoint._privateConstructor();
  static final AppApiEndPoint _instance = AppApiEndPoint._privateConstructor();
  static AppApiEndPoint get instance => _instance;

  //app use base
  static final String domain = _getDomain();
  final String baseUrl = "$domain/api/v1";

  // auth api end point
  static final String authLogin = "/auth/login";
  static final String signUpEndPoint = "/user";
  static final String verifyEmail = "/auth/verify-email";
  static final String forgotPassEndPoint = "/auth/forget-password";
  static final String resetPasswordEndPoint = "/auth/reset-password";
  static final String changePasswordEndPoint = "/auth/change-password";
  String disclaimer({required String type}) => "/disclaimer?type=$type";
  static final String faqEndPoint = "/faq";

}

// Move this function outside the class
String _getDomain() {
  ///////////10.0.70.208:3001///////////////////////
  // String liveServer = "http://10.0.70.208:10.0.70.30:3002";
  // String localServer = "http://10.0.70.208:3001";
  //////////LIVE////////////////////////
  // String liveServer = "http://195.35.9.21:3001";
  // String localServer = "http://10.0.70.30:3002";
  //////////10.0.70.30:3002////////////////////////
  String liveServer = "http://10.10.7.9:5013";
  String localServer = "http://10.10.7.9:5013";
  try {
    if (kDebugMode) {
      return localServer;
    }
    return liveServer;
  } catch (e) {
    errorLog(
      "_getDomain $e",
    );
    return liveServer;
  }
  // return liveServer;
}
