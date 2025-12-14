class FAQ {
  int? statusCode;
  bool? success;
  String? message;
  List<FAQData>? data;

  FAQ({this.statusCode, this.success, this.message, this.data});

  FAQ.fromJson(Map json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FAQData>[];
      json['data'].forEach((v) {
        data!.add(FAQData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FAQData {
  String? sId;
  String? question;
  String? answer;
  String? createdAt;
  String? updatedAt;
  int? iV;

  FAQData(
      {this.sId,
      this.question,
      this.answer,
      this.createdAt,
      this.updatedAt,
      this.iV});

  FAQData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    question = json['question'];
    answer = json['answer'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['question'] = question;
    data['answer'] = answer;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
