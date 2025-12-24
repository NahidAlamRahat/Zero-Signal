class ActivityListModel {
  final bool? success;
  final String? message;
  final Pagination? pagination;
  final List<ActivityListData>? data;

  ActivityListModel({
    this.success,
    this.message,
    this.pagination,
    this.data,
  });

  factory ActivityListModel.fromJson(Map<String, dynamic> json) {
    return ActivityListModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((e) => ActivityListData.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

class Pagination {
  final int? total;
  final int? limit;
  final int? page;
  final int? totalPage;

  Pagination({
    this.total,
    this.limit,
    this.page,
    this.totalPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] as int?,
      limit: json['limit'] as int?,
      page: json['page'] as int?,
      totalPage: json['totalPage'] as int?,
    );
  }
}

class ActivityListData {
  final String? sId;
  final String? user;
  final String? title;
  final String? description;
  final List<String>? images;
  final String? type;
  final String? address;
  final String? date;
  final int? maxParticipants;
  final int? currentParticipants;
  final String? createdAt;
  final String? updatedAt;
  final Location? location;

  ActivityListData({
    this.sId,
    this.user,
    this.title,
    this.description,
    this.images,
    this.type,
    this.address,
    this.date,
    this.maxParticipants,
    this.currentParticipants,
    this.createdAt,
    this.updatedAt,
    this.location,
  });

  factory ActivityListData.fromJson(Map<String, dynamic> json) {
    return ActivityListData(
      sId: json['_id'] as String?,
      user: json['user'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : null,
      type: json['type'] as String?,
      address: json['address'] as String?,
      date: json['date'] as String?,
      maxParticipants: json['max_participants'] as int?,
      currentParticipants: json['current_participants'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      location: json['location'] != null
          ? Location.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Location {
  final String? type;
  final List<double>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] as String?,
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'] as List)
          : null,
    );
  }
}
