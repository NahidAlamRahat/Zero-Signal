import 'package:geolocator/geolocator.dart';

enum TravelMode { walking, driving }

class NavigationController {
  bool isNavigating = false;
  TravelMode mode = TravelMode.driving;

  Position? currentPosition;
  double speedKmh = 0;
  double remainingDistance = 0;
  int etaMinutes = 0;

  DateTime? startTime;
  Duration get elapsedDuration =>
      startTime != null ? DateTime.now().difference(startTime!) : Duration.zero;
  String get elapsedFormatted {
    final d = elapsedDuration;
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  String get pace => speedKmh > 0 ? (60 / speedKmh).toStringAsFixed(1) : "0.0";

  List<Map<String, dynamic>> route = [];
  bool hasSpoken = false;
  int closestIdx = 0;

  void start(Position pos, List<Map<String, dynamic>> points) {
    isNavigating = true;
    currentPosition = pos;
    route = points;
    startTime = DateTime.now();
    _updateStats();
  }

  void stop() {
    isNavigating = false;
    startTime = null;
  }

  void updatePosition(Position pos) {
    currentPosition = pos;
    // Use real speed from GPS, but provide a minimum fallback for ETA calculation if moving
    speedKmh = pos.speed * 3.6;
    _updateStats();
  }

  void _updateStats() {
    if (route.isEmpty || currentPosition == null) return;

    // Calculate remaining distance from current position to the end of the route
    // In a sophisticated engine, we'd snap to the route first.
    // For now, we sum distances from the current point to the remaining waypoints.

    // Simple implementation: find the closest point and sum from there
    double minDist = double.infinity;
    int closestIdx = 0;

    for (int i = 0; i < route.length; i++) {
      double dist = Geolocator.distanceBetween(
          currentPosition!.latitude,
          currentPosition!.longitude,
          route[i]['latitude'],
          route[i]['longitude']);
      if (dist < minDist) {
        minDist = dist;
        closestIdx = i;
      }
    }

    this.closestIdx = closestIdx;
    double distSum = minDist;
    for (int i = closestIdx; i < route.length - 1; i++) {
      distSum += Geolocator.distanceBetween(
          route[i]['latitude'],
          route[i]['longitude'],
          route[i + 1]['latitude'],
          route[i + 1]['longitude']);
    }

    remainingDistance = distSum;

    // Update ETA
    double effectiveSpeed = speedKmh;
    if (effectiveSpeed < 2) {
      // Fallback speed if stopped or moving very slowly (walking/driving average)
      effectiveSpeed = (mode == TravelMode.walking) ? 5.0 : 20.0;
    }

    etaMinutes = (remainingDistance / 1000 / effectiveSpeed * 60).round();
  }
}
