class ProfileModel {
  bool? success;
  String? message;
  ProfileData? data;

  ProfileModel({this.success, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? ProfileData.fromJson(json['data']) : null;
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

class ProfileData {
  String? sId;
  String? name;
  String? role;
  String? email;
  String? image;
  String? status;
  bool? verified;
  String? dateOfBirth;
  bool? isSocialLogin;
  String? createdAt;
  String? updatedAt;
  String? username;
  int? iV;
  String? address;
  String? bio;
  String? gender;
  String? meInOneSentence;

  ProfileData(
      {this.sId,
      this.name,
      this.role,
      this.email,
      this.image,
      this.status,
      this.verified,
      this.dateOfBirth,
      this.isSocialLogin,
      this.createdAt,
      this.updatedAt,
      this.username,
      this.iV,
      this.address,
      this.bio,
      this.gender,
      this.meInOneSentence});

  ProfileData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    role = json['role'];
    email = json['email'];
    image = json['image'];
    status = json['status'];
    verified = json['verified'];
    dateOfBirth = json['date_of_birth'];
    isSocialLogin = json['is_social_login'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    username = json['username'];
    iV = json['__v'];
    address = json['address'];
    bio = json['bio'];
    gender = json['gender'];
    meInOneSentence = json['me_in_one_sentence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['role'] = role;
    data['email'] = email;
    data['image'] = image;
    data['status'] = status;
    data['verified'] = verified;
    data['date_of_birth'] = dateOfBirth;
    data['is_social_login'] = isSocialLogin;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['username'] = username;
    data['__v'] = iV;
    data['address'] = address;
    data['bio'] = bio;
    data['gender'] = gender;
    data['me_in_one_sentence'] = meInOneSentence;
    return data;
  }
}
