import 'dart:math' as math;

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

class TrackingDebugUtils {
  static double distanceMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371000.0;

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.asin(math.sqrt(a));
    return earthRadius * c;
  }

  static mapbox.Position generateRandomDestinationAround(
    double startLat,
    double startLng, {
    double distanceMeters = 7000,
    int seed = 1,
  }) {
    const earthRadius = 6371000.0;
    final rnd = math.Random(seed);

    final bearing = rnd.nextDouble() * 2 * math.pi;
    final angularDistance = distanceMeters / earthRadius;

    final lat1 = _toRadians(startLat);
    final lon1 = _toRadians(startLng);

    final lat2 = math.asin(
      math.sin(lat1) * math.cos(angularDistance) +
          math.cos(lat1) * math.sin(angularDistance) * math.cos(bearing),
    );

    final lon2 = lon1 +
        math.atan2(
          math.sin(bearing) * math.sin(angularDistance) * math.cos(lat1),
          math.cos(angularDistance) - math.sin(lat1) * math.sin(lat2),
        );

    final destLat = _toDegrees(lat2);
    final destLng = _toDegrees(lon2);
    return mapbox.Position(destLng, destLat);
  }

  static double _toRadians(double degrees) => degrees * (math.pi / 180.0);

  static double _toDegrees(double radians) => radians * (180.0 / math.pi);
}
