import 'dart:async';
import 'dart:convert' as convert;
import 'dart:math';
import 'package:http/http.dart' as http;

class RouteService {
  static Future<bool> fetchRealRoadRoute(
    List<Map<String, dynamic>> routeCoordinates,
    Function(List<Map<String, dynamic>>) onRouteReceived,
  ) async {
    if (routeCoordinates.length < 2) return false;

    print('=== FETCHING REAL ROAD ROUTE ===');

    try {
      final startCoord = routeCoordinates.first;
      final endCoord = routeCoordinates.last;
      
      // Use OpenStreetMap's OSRM routing service (free and reliable)
      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${startCoord['longitude']},${startCoord['latitude']};'
        '${endCoord['longitude']},${endCoord['latitude']}'
        '?overview=full&geometries=geojson'
      );

      print('Request URL: $url');

      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = convert.json.decode(response.body);
        print('OSRM Response received');
        
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final geometry = route['geometry'];
          final coordinates = geometry['coordinates'] as List;
          
          // Convert API coordinates to our format
          final routeWaypoints = coordinates.map((coord) => {
            'latitude': coord[1],
            'longitude': coord[0],
          }).toList();

          print('Got ${routeWaypoints.length} road waypoints from OSRM');
          onRouteReceived(routeWaypoints);
          return true;
        }
      }
    } catch (e) {
      print('Error fetching real road route: $e');
    }
    
    return false;
  }

  static List<Map<String, dynamic>> generateIntermediateWaypoints(
    double startLat, double startLng, double endLat, double endLng
  ) {
    final waypoints = <Map<String, dynamic>>[];
    final numWaypoints = 8; // Number of intermediate points
    
    for (int i = 0; i <= numWaypoints; i++) {
      final t = i / numWaypoints;
      
      // Basic interpolation with some curve
      final lat = startLat + (endLat - startLat) * t;
      final lng = startLng + (endLng - startLng) * t;
      
      // Add some curve for more realistic path
      final curveOffset = sin(t * pi) * 0.01; // Small curve
      final finalLng = lng + curveOffset;
      
      waypoints.add({
        'latitude': lat,
        'longitude': finalLng,
      });
    }
    
    return waypoints;
  }

  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  static double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }
}
