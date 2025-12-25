class ActivityFeedModel {
  bool? success;
  String? message;
  Pagination? pagination;
  List<ActivityFeedData>? data;

  ActivityFeedModel({this.success, this.message, this.pagination, this.data});

  ActivityFeedModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <ActivityFeedData>[];
      json['data'].forEach((v) {
        data!.add(ActivityFeedData.fromJson(v));
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
  int? page;
  int? limit;
  int? total;
  int? totalPage;

  Pagination({this.page, this.limit, this.total, this.totalPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPage = json['totalPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    data['total'] = total;
    data['totalPage'] = totalPage;
    return data;
  }
}

class ActivityFeedData {
  String? sId;
  User? user;
  String? title;
  String? description;
  List<String>? images;
  String? type;
  String? address;
  String? date;
  int? maxParticipants;
  int? currentParticipants;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Location? location;
  double? distance;
  List<User>? participants;
  int? saved;
  bool? isSaved;

  ActivityFeedData(
      {this.sId,
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
      this.iV,
      this.location,
      this.distance,
      this.participants,
      this.isSaved,
      this.saved});

  ActivityFeedData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    title = json['title'];
    description = json['description'];
    images = json['images'] != null ? List<String>.from(json['images']) : null;
    type = json['type'];
    address = json['address'];
    date = json['date'];
    maxParticipants = json['max_participants'];
    currentParticipants = json['current_participants'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    distance = (json['distance'] as num?)?.toDouble();
    if (json['perticipants'] != null) {
      participants = <User>[];
      json['perticipants'].forEach((v) {
        participants!.add(User.fromJson(v));
      });
    }
    saved = json['saved'];
    isSaved = json['is_saved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['title'] = title;
    data['description'] = description;
    data['images'] = images;
    data['type'] = type;
    data['address'] = address;
    data['date'] = date;
    data['max_participants'] = maxParticipants;
    data['current_participants'] = currentParticipants;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['distance'] = distance;
    if (participants != null) {
      data['perticipants'] = participants!.map((v) => v.toJson()).toList();
    }
    data['saved'] = saved;
    data['is_saved'] = isSaved;
    return data;
  }
}

class User {
  String? sId;
  String? name;
  String? email;
  String? image;
  String? dateOfBirth;
  String? username;
  String? address;

  User(
      {this.sId,
      this.name,
      this.email,
      this.image,
      this.dateOfBirth,
      this.username,
      this.address});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
    dateOfBirth = json['date_of_birth'];
    username = json['username'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['image'] = image;
    data['date_of_birth'] = dateOfBirth;
    data['username'] = username;
    data['address'] = address;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'] != null
        ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}
