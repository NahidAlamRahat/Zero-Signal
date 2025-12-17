import 'dart:io';

/// Request model for creating a new spot
class SpotRequestModel {
  final String title;
  final String description;
  final String address;
  final double lat;
  final double lng;
  final String type; // subcategory ID
  final List<File> images;

  SpotRequestModel({
    required this.title,
    required this.description,
    required this.address,
    required this.lat,
    required this.lng,
    required this.type,
    required this.images,
  });

  /// Convert to Map for API request (excluding images which need multipart handling)
  Map<String, dynamic> toFormData() {
    return {
      'title': title,
      'description': description,
      'address': address,
      'lat': lat.toString(),
      'lng': lng.toString(),
      'type': type,
    };
  }

  /// Validate the request model
  bool isValid() {
    return title.isNotEmpty &&
        description.isNotEmpty &&
        address.isNotEmpty &&
        type.isNotEmpty;
  }

  /// Get validation error message
  String? getValidationError() {
    if (title.isEmpty) return 'Please enter a title';
    if (description.isEmpty) return 'Please enter a description';
    if (address.isEmpty) return 'Please set a location';
    if (type.isEmpty) return 'Please select a spot type';
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
