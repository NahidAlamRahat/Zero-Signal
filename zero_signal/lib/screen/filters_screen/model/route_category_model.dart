class RouteCategoryModel {
  final String id;
  final String name;
  final String icon;
  final String createdAt;
  final String updatedAt;

  RouteCategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RouteCategoryModel.fromJson(Map<String, dynamic> json) {
    return RouteCategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'icon': icon,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
