import 'dart:io';

/// Request model for creating a new route
class RouteRequestModel {
  final String title;
  final String description;
  final String startAddress;
  final double startLat;
  final double startLng;
  final String endAddress;
  final double endLat;
  final double endLng;
  final String type; // subcategory ID
  final List<File> images;

  RouteRequestModel({
    required this.title,
    required this.description,
    required this.startAddress,
    required this.startLat,
    required this.startLng,
    required this.endAddress,
    required this.endLat,
    required this.endLng,
    required this.type,
    required this.images,
  });

  /// Convert to Map for API request (excluding images which need multipart handling)
  Map<String, dynamic> toFormData() {
    return {
      'title': title,
      'description': description,
      'start_address': startAddress,
      'start_lat': startLat.toString(),
      'start_lng': startLng.toString(),
      'end_address': endAddress,
      'end_lat': endLat.toString(),
      'end_lng': endLng.toString(),
      'type': type,
    };
  }

  /// Validate the request model
  bool isValid() {
    return title.isNotEmpty &&
        description.isNotEmpty &&
        startAddress.isNotEmpty &&
        endAddress.isNotEmpty &&
        type.isNotEmpty;
  }

  /// Get validation error message
  String? getValidationError() {
    if (title.isEmpty) return 'Please enter a title';
    if (description.isEmpty) return 'Please enter a description';
    if (startAddress.isEmpty) return 'Please set a start location';
    if (endAddress.isEmpty) return 'Please set an end location';
    if (type.isEmpty) return 'Please select a route type';
    return null;
  }
}

/// Mapbox Places API suggestion model
class MapboxPlaceSuggestion {
  final String id;
  final String placeName;
  final String text;
  final double? latitude;
  final double? longitude;

  MapboxPlaceSuggestion({
    required this.id,
    required this.placeName,
    required this.text,
    this.latitude,
    this.longitude,
  });

  factory MapboxPlaceSuggestion.fromJson(Map<String, dynamic> json) {
    List<dynamic>? center = json['center'];
    return MapboxPlaceSuggestion(
      id: json['id'] ?? '',
      placeName: json['place_name'] ?? '',
      text: json['text'] ?? '',
      longitude:
          center != null && center.isNotEmpty ? center[0]?.toDouble() : null,
      latitude:
          center != null && center.length > 1 ? center[1]?.toDouble() : null,
    );
  }
}
