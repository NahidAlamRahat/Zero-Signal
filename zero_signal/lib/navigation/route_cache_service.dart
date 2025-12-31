import 'package:hive_flutter/hive_flutter.dart';

class RouteCacheService {
  static const String _boxName = "offline_routes";

  static Future<void> init() async {
    await Hive.initFlutter();
  }

  static Future<void> saveRoute(
      String id, List<Map<String, dynamic>> coordinates) async {
    var box = await Hive.openBox(_boxName);
    await box.put(id, coordinates);
  }

  static Future<List<Map<String, dynamic>>?> getRoute(String id) async {
    var box = await Hive.openBox(_boxName);
    var data = box.get(id);
    if (data == null) return null;

    // Convert back to List<Map<String, dynamic>> carefully
    try {
      return (data as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } catch (e) {
      print('Error parsing cached route: $e');
      return null;
    }
  }

  static Future<void> clearCache() async {
    var box = await Hive.openBox(_boxName);
    await box.clear();
  }
}
