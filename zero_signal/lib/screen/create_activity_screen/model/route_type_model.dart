class RouteTypeModel {
  bool? success;
  String? message;
  List<RouteTypeData>? data;

  RouteTypeModel({this.success, this.message, this.data});

  RouteTypeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RouteTypeData>[];
      json['data'].forEach((v) {
        data!.add(RouteTypeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RouteTypeData {
  String? sId;
  String? name;
  String? icon;
  String? createdAt;
  String? updatedAt;
  int? iV;

  RouteTypeData(
      {this.sId,
      this.name,
      this.icon,
      this.createdAt,
      this.updatedAt,
      this.iV});

  RouteTypeData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    icon = json['icon'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['icon'] = icon;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
