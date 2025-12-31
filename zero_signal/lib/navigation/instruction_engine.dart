import 'dart:math';

class InstructionEngine {
  /// Calculates the bearing between two points
  static double calculateBearing(
      double lat1, double lon1, double lat2, double lon2) {
    final dLon = (lon2 - lon1) * pi / 180;
    final lat1Rad = lat1 * pi / 180;
    final lat2Rad = lat2 * pi / 180;

    final y = sin(dLon) * cos(lat2Rad);
    final x =
        cos(lat1Rad) * sin(lat2Rad) - sin(lat1Rad) * cos(lat2Rad) * cos(dLon);

    final brng = atan2(y, x);
    return (brng * 180 / pi + 360) % 360;
  }

  /// Returns a human-readable instruction based on bearing difference
  static String getInstruction(double currentBearing, double nextBearing) {
    double diff = (nextBearing - currentBearing + 180) % 360 - 180;

    if (diff.abs() < 15) return "Continue straight";
    if (diff.abs() < 45) {
      return diff > 0 ? "Slight right" : "Slight left";
    }
    if (diff.abs() < 120) {
      return diff > 0 ? "Turn right" : "Turn left";
    }
    return "Make a U-turn";
  }
}
