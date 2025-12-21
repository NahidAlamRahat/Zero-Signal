class SupportResponseModel {
  bool? success;
  String? message;
  Data? data;

  SupportResponseModel({this.success, this.message, this.data});

  SupportResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? message;
  String? user;

  Data({this.message, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['user'] = user;
    return data;
  }
}
