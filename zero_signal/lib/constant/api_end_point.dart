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

  //'Activity' | 'Route' | 'Spot'
  String getFavoriteEndPoint(String type) => "/favorite?type=$type";
  static String toggleFavoriteEndPoint() => "/favorite";
  String mySpotDetailEndPoint(String id) => "/spot/$id";
  static final String categoryEndPoint = "/category?withSub=true";
  static final String routeEndPoint = "/route";
  static final String spotEndPoint = "/spot";
  static final String getProfile = "/user/profile";
  static final String updateProfile = "/user/profile";
  static final String supportEndPoint = "/support";
  String routeDetailEndPoint(String id) => "/route/$id";
  String routeTypeEndPoint() => "/category/route-type";
  static final String activityEndPoint = "/activity";
  String activityFeedEndPoint(lat, lng) =>
      "/activity/feed?lat=$lat&lng=$lng&radius=10000";

  static final String activitySaveEndPoint = "/activity/save";
  String activityJoinEndPoint() => "/activity/join";

  //'all' | 'created' | 'joined' | 'saved'
  String activityByTypeEndPoint(String type, {int page = 1}) =>
      "/activity?type=$type&page=$page";

  String activityLeaveEndPoint() => "/activity/leave";
  String activityUpdateEndPoint(String id) => "/activity/$id";
  String getSingleActivityEndPoint(String id) => "/activity/$id";
  String messageEndPoint(String activityId, {int page = 1}) =>
      "/message/$activityId?page=$page";
  String memberListEndPoint(String activityId) =>
      "/activity/member-list/$activityId";
  static final String sendMessageEndPoint = "/message";
  //String activityByTypeEndPoint(String type) => "/activity?type=$type";
  static final String spotCoordinatesEndPoint = "/spot/coordinates";
  static final String reportEndPoint = "/report";

  /// ========================= Atik Hridoy =====================

  static final String mySpotEndPoint = "/spot";
  static final String createSpotEndPoint = "/spot";
  static final String getRouteEndPoint = "/route/geocode";
  static final String createRoute = "/route";


  // comment
  static final String commentEndPoint = "/comment";
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
  String liveServer = "https://shariful5000.binarybards.online";
  String localServer = "https://shariful5000.binarybards.online";
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
