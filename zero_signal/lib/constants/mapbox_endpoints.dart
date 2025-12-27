class MapboxEndpoints {
  // Base configuration
  static const String baseUrl = 'https://api.mapbox.com';
  static const String version = 'v5';
  static const String dataset = 'mapbox.places';
  
  // Geocoding endpoints
  static String geocoding(String query, String accessToken, {
    int? limit,
    bool autocomplete = false,
  }) {
    final Map<String, String> queryParams = {
      'access_token': accessToken,
      if (limit != null) 'limit': limit.toString(),
      if (autocomplete) 'autocomplete': 'true',
    };
    
    final uri = Uri(
      scheme: 'https',
      host: 'api.mapbox.com',
      path: 'geocoding/$version/$dataset/$query.json',
      queryParameters: queryParams,
    );
    
    return uri.toString();
  }
  
  static String forwardGeocoding(String query, String accessToken, {int limit = 1}) {
    return geocoding(query, accessToken, limit: limit);
  }
  
  static String autocompleteGeocoding(String query, String accessToken, {int limit = 5}) {
    return geocoding(query, accessToken, limit: limit, autocomplete: true);
  }
  
  static String reverseGeocoding(double longitude, double latitude, String accessToken) {
    final coordinates = '$longitude,$latitude';
    return geocoding(coordinates, accessToken);
  }
  
  // Directions endpoints
  static String directions(String accessToken) {
    return 'https://api.mapbox.com/directions/v5/mapbox/driving';
  }
  
  // Static tiles endpoints
  static String staticTiles(String accessToken) {
    return 'https://api.mapbox.com/styles/v1';
  }
  
  // Tilesets endpoints
  static String tilesets(String accessToken) {
    return 'https://api.mapbox.com/tilesets/v1';
  }
}
