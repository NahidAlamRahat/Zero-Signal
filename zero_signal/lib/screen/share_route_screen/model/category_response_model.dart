/// Category API response model
/// Endpoint: GET /category?withSub=true
class CategoryResponse {
  final bool success;
  final String message;
  final List<CategoryData> data;

  CategoryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List).map((e) => CategoryData.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class CategoryData {
  final String id;
  final String name;
  final List<SubcategoryData> subcategories;

  CategoryData({
    required this.id,
    required this.name,
    required this.subcategories,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      subcategories: json['subcategories'] != null
          ? (json['subcategories'] as List)
              .map((e) => SubcategoryData.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'subcategories': subcategories.map((e) => e.toJson()).toList(),
    };
  }
}

class SubcategoryData {
  final String id;
  final String name;
  bool isSelected;

  SubcategoryData({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  factory SubcategoryData.fromJson(Map<String, dynamic> json) {
    return SubcategoryData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      isSelected: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}
