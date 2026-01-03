class RouteModel {
  bool? success;
  String? message;
  Pagination? pagination;
  List<RouteData>? data;

  RouteModel({this.success, this.message, this.pagination, this.data});

  RouteModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <RouteData>[];
      json['data'].forEach((v) {
        data!.add(RouteData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int? total;
  int? limit;
  int? page;
  int? totalPage;

  Pagination({this.total, this.limit, this.page, this.totalPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    limit = json['limit'];
    page = json['page'];
    totalPage = json['totalPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['limit'] = limit;
    data['page'] = page;
    data['totalPage'] = totalPage;
    return data;
  }
}

class RouteData {
  Location? location;
  String? sId;
  double? initalLat;
  double? initalLng;
  double? finalLat;
  double? finalLng;
  String? title;
  String? description;
  User? user;
  String? type;
  String? difficulty;
  List<String>? images;
  String? typeOfRoute;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Distance? distance;
  Duration? duration;
  bool? isFavorite;

  RouteData(
      {this.location,
      this.sId,
      this.initalLat,
      this.initalLng,
      this.finalLat,
      this.finalLng,
      this.title,
      this.description,
      this.user,
      this.type,
      this.difficulty,
      this.images,
      this.typeOfRoute,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.distance,
      this.duration,
      this.isFavorite});

  RouteData.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    sId = json['_id'];
    initalLat = (json['inital_lat'] as num?)?.toDouble();
    initalLng = (json['inital_lng'] as num?)?.toDouble();
    finalLat = (json['final_lat'] as num?)?.toDouble();
    finalLng = (json['final_lng'] as num?)?.toDouble();
    title = json['title'];
    description = json['description'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    type = json['type'];
    difficulty = json['difficulty'];
    if (json['images'] != null) {
      images = List<String>.from(json['images']);
    } else {
      images = [];
    }
    typeOfRoute = json['type_of_route'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    distance =
        json['distance'] != null ? Distance.fromJson(json['distance']) : null;
    duration =
        json['duration'] != null ? Duration.fromJson(json['duration']) : null;
    isFavorite = json['is_favorite'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['_id'] = sId;
    data['inital_lat'] = initalLat;
    data['inital_lng'] = initalLng;
    data['final_lat'] = finalLat;
    data['final_lng'] = finalLng;
    data['title'] = title;
    data['description'] = description;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['type'] = type;
    data['difficulty'] = difficulty;
    data['images'] = images;
    data['type_of_route'] = typeOfRoute;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (distance != null) {
      data['distance'] = distance!.toJson();
    }
    if (duration != null) {
      data['duration'] = duration!.toJson();
    }
    data['isFavorite'] = isFavorite;
    return data;
  }

  String getFirstImageUrl() {
    if (images != null && images!.isNotEmpty) {
      return images!.first;
    }
    return "";
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class User {
  String? sId;
  String? name;
  String? email;
  String? image;
  String? dateOfBirth;
  String? address;

  User(
      {this.sId,
      this.name,
      this.email,
      this.image,
      this.dateOfBirth,
      this.address});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
    dateOfBirth = json['date_of_birth'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['image'] = image;
    data['date_of_birth'] = dateOfBirth;
    data['address'] = address;
    return data;
  }
}

class Distance {
  String? text;
  num? value;
  String? sId;

  Distance({this.text, this.value, this.sId});

  Distance.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['value'] = value;
    data['_id'] = sId;
    return data;
  }
}

class Duration {
  String? text;
  num? value;
  String? sId;

  Duration({this.text, this.value, this.sId});

  Duration.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['value'] = value;
    data['_id'] = sId;
    return data;
  }
}
