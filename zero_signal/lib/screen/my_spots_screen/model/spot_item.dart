class SpotItem {
  final String id;
  final String name;
  final String uploadDate;
  final String imageUrl;
  bool isFavorite;

  SpotItem({
    required this.id,
    required this.name,
    required this.uploadDate,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // CopyWith method for immutability
  SpotItem copyWith({
    String? id,
    String? name,
    String? uploadDate,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return SpotItem(
      id: id ?? this.id,
      name: name ?? this.name,
      uploadDate: uploadDate ?? this.uploadDate,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}