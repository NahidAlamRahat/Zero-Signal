class MySpotsResponseModel {
  final bool success;
  final String message;
  final Pagination? pagination;
  final List<SpotData> data;

  MySpotsResponseModel({
    required this.success,
    required this.message,
    this.pagination,
    required this.data,
  });

  factory MySpotsResponseModel.fromJson(Map<String, dynamic> json) {
    return MySpotsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      data: json['data'] != null
          ? (json['data'] as List).map((e) => SpotData.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'pagination': pagination?.toJson(),
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Pagination {
  final int total;
  final int limit;
  final int page;
  final int totalPage;

  Pagination({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] ?? 0,
      limit: json['limit'] ?? 10,
      page: json['page'] ?? 1,
      totalPage: json['totalPage'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'limit': limit,
      'page': page,
      'totalPage': totalPage,
    };
  }
}

class SpotData {
  final String id;
  final List<String> images;
  final String title;
  final String description;
  final String address;
  final LocationData location;
  final String type;
  final String user;
  final double lat;
  final double lng;
  final String createdAt;
  final String updatedAt;

  SpotData({
    required this.id,
    required this.images,
    required this.title,
    required this.description,
    required this.address,
    required this.location,
    required this.type,
    required this.user,
    required this.lat,
    required this.lng,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SpotData.fromJson(Map<String, dynamic> json) {
    return SpotData(
      id: json['_id'] ?? '',
      images: json['images'] != null
          ? (json['images'] as List).map((e) => e.toString()).toList()
          : [],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      location: json['location'] != null
          ? LocationData.fromJson(json['location'])
          : LocationData(type: 'Point', coordinates: [0, 0]),
      type: json['type'] ?? '',
      user: json['user'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'images': images,
      'title': title,
      'description': description,
      'address': address,
      'location': location.toJson(),
      'type': type,
      'user': user,
      'lat': lat,
      'lng': lng,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Helper method to get the first image URL or empty string
  String getFirstImageUrl() {
    if (images.isNotEmpty) {
      return images[0];
    }
    return '';
  }

  // Helper method to check if images exist
  bool hasImages() {
    return images.isNotEmpty;
  }
}

class LocationData {
  final String type;
  final List<double> coordinates;

  LocationData({
    required this.type,
    required this.coordinates,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      type: json['type'] ?? 'Point',
      coordinates: json['coordinates'] != null
          ? (json['coordinates'] as List)
              .map((e) => (e as num).toDouble())
              .toList()
          : [0, 0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}
