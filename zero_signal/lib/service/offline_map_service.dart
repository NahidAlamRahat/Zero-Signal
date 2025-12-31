import 'dart:async';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import '../../utils/app_log/app_log.dart';

/// Service for managing offline map regions using Mapbox Maps SDK v2.17.0
class OfflineMapService {
  /// Mapbox instances
  mapbox.OfflineManager? _offlineManager;
  mapbox.TileStore? _tileStore;

  /// Ensures that Mapbox instances are initialized
  Future<void> _ensureInitialized() async {
    _offlineManager ??= await mapbox.OfflineManager.create();
    _tileStore ??= await mapbox.TileStore.createDefault();
  }

  /// Default region ID
  final String defaultRegionId = "offline_region";

  /// Downloads an offline map region
  /// [bounds] : southwest & northeast coordinates
  /// [minZoom] : minimum zoom level
  /// [maxZoom] : maximum zoom level
  /// [styleUri] : Mapbox style URI
  /// [regionId] : optional custom region ID
  /// [onProgress] : callback with progress value (0.0 - 1.0)
  Future<void> downloadRegion({
    required mapbox.CoordinateBounds bounds,
    required double minZoom,
    required double maxZoom,
    required String styleUri,
    String? regionId,
    Function(double)? onProgress,
  }) async {
    final id = regionId ?? defaultRegionId;

    try {
      await _ensureInitialized();

      final sw = bounds.southwest.coordinates;
      final ne = bounds.northeast.coordinates;

      // Construct a Polygon using Position(lng, lat)
      final polygon = mapbox.Polygon(
        coordinates: [
          [
            mapbox.Position(sw.lng, sw.lat),
            mapbox.Position(ne.lng, sw.lat),
            mapbox.Position(ne.lng, ne.lat),
            mapbox.Position(sw.lng, ne.lat),
            mapbox.Position(sw.lng, sw.lat),
          ]
        ],
      );

      // Create tileset descriptor options
      final tilesetDescriptorOptions = mapbox.TilesetDescriptorOptions(
        styleURI: styleUri,
        minZoom: minZoom.toInt(),
        maxZoom: maxZoom.toInt(),
      );

      // Create tile region load options
      final options = mapbox.TileRegionLoadOptions(
        geometry: polygon.toJson(),
        descriptorsOptions: [tilesetDescriptorOptions],
        acceptExpired: true,
        networkRestriction: mapbox.NetworkRestriction.NONE,
        metadata: {
          "regionName": id,
          "minZoom": minZoom,
          "maxZoom": maxZoom,
        },
      );

      // loadTileRegion takes (id, options, progressCallback)
      _tileStore!.loadTileRegion(
        id,
        options,
        (progress) {
          final completed = progress.completedResourceCount;
          final total = progress.requiredResourceCount;

          if (total > 0) {
            final percent = completed / total;
            if (onProgress != null) onProgress(percent);
            appLog(
              'Offline download progress: ${(percent * 100).toStringAsFixed(1)}%',
              type: LogType.info,
              source: 'OFFLINE_MAP',
            );
          }
        },
      );

      appLog('Offline download started for region: $id',
          type: LogType.info, source: 'OFFLINE');
    } catch (e, stack) {
      appLog('Failed to start offline download: $e\n$stack',
          type: LogType.error, source: 'OFFLINE');
    }
  }

  /// Deletes an offline region
  Future<void> deleteRegion({String? regionId}) async {
    final id = regionId ?? defaultRegionId;
    try {
      await _ensureInitialized();
      await _tileStore!.removeRegion(id);
      appLog('Offline region removed: $id',
          type: LogType.info, source: 'OFFLINE');
    } catch (e, stack) {
      appLog('Failed to remove offline region: $e\n$stack',
          type: LogType.error, source: 'OFFLINE');
    }
  }

  /// Lists all downloaded offline regions
  Future<List<mapbox.TileRegion>> listRegions() async {
    try {
      await _ensureInitialized();
      final regions = await _tileStore!.allTileRegions();
      appLog('Found ${regions.length} offline regions',
          type: LogType.info, source: 'OFFLINE');
      return regions;
    } catch (e, stack) {
      appLog('Failed to list offline regions: $e\n$stack',
          type: LogType.error, source: 'OFFLINE');
      return [];
    }
  }

  /// Checks if a specific offline region exists
  Future<bool> hasRegion({String? regionId}) async {
    final id = regionId ?? defaultRegionId;
    try {
      await _ensureInitialized();
      final regions = await _tileStore!.allTileRegions();
      final exists = regions.any((r) => r.id == id);
      appLog('Offline region "$id" exists: $exists',
          type: LogType.info, source: 'OFFLINE');
      return exists;
    } catch (e, stack) {
      appLog('Failed to check offline region: $e\n$stack',
          type: LogType.error, source: 'OFFLINE');
      return false;
    }
  }
}
