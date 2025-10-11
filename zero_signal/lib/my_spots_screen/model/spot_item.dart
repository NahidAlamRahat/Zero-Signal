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
}