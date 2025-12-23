# Location Map Widget Implementation

## Overview
A reusable `LocationMapWidget` has been created and integrated across multiple screens to display spot locations on an interactive Mapbox map.

## Files Created
- `lib/screen/list_view_details_screen/widget/location_map_widget.dart` - Reusable map widget component

## Files Updated

### 1. **List View Details Screen**
- **File**: `lib/screen/list_view_details_screen/list_view_details_screen.dart`
- **Changes**: 
  - Added `LocationMapWidget` import
  - Added `_buildLocationMap()` method
  - Integrated map display between title and description sections
  - Shows spot location with marker at coordinates

### 2. **Share Spot Screen**
- **File**: `lib/screen/share_spot_screen/share_spot_screen.dart`
- **Changes**:
  - Added `LocationMapWidget` import
  - Added map preview after location search widget
  - Shows selected location in real-time as user searches
  - Displays placeholder message when no location is selected
  - Fixed deprecated `withOpacity()` → `withValues(alpha: 0.5)`

### 3. **Sunset Point Details Screen**
- **File**: `lib/screen/sunset_point_details_screen/sunset_point_details_screen.dart`
- **Changes**:
  - Added `LocationMapWidget` import
  - Added `_buildLocationMap()` method
  - Integrated map display between title and description sections
  - Uses actual spot coordinates from API response
  - Fixed deprecated `withOpacity()` → `withValues(alpha: 0.5)`

## LocationMapWidget Features

### Properties
- `latitude` (double, required) - Latitude coordinate
- `longitude` (double, required) - Longitude coordinate
- `markerTitle` (String, required) - Title for the marker
- `height` (double, default: 250) - Height of the map widget

### Functionality
- Displays Mapbox map with custom marker
- Rounded corners with ClipRRect
- Automatic camera positioning to coordinates
- Marker at specified location
- Disabled compass and scale bar for cleaner UI
- Responsive and reusable across screens

### Map Configuration
- Style: `mapbox://styles/mapbox/streets-v12`
- Zoom Level: 14.0
- Marker Icon: `marker-15` (built-in Mapbox icon)
- Marker Size: 2.0

## Usage Example

```dart
LocationMapWidget(
  latitude: 23.777628,
  longitude: 90.405449,
  markerTitle: 'My Spot',
  height: 250,
)
```

## Integration Points

### Home Screen
- Already has full map functionality with search and filtering
- Uses `HomeScreenController` for map management

### Spot Details Screens
- Display read-only map preview of spot location
- Shows marker at spot coordinates
- Helps users visualize spot location

### Share Spot Screen
- Shows real-time map preview as user selects location
- Helps confirm location selection before submission
- Updates automatically when location changes

## API Response Integration
The widget uses coordinates from API responses:
- **Spots API**: Uses `lat` and `lng` fields from spot data
- **Mapbox Geocoding**: Uses `coordinates` from search results

## Styling
- Rounded corners: 16px radius
- Consistent with app design system
- Uses Mapbox default styling
- Responsive to screen size

## Future Enhancements
- Add custom marker icons
- Add location search within map
- Add route drawing on map
- Add multiple markers support
- Add map type switching (satellite, terrain)
