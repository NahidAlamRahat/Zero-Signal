// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:zero_signal/debug/tracking_debug_utils.dart';

void main() {
  test('Generate random destination about 7km away', () {
    const startLat = 23.8103;
    const startLng = 90.4125;

    final dest = TrackingDebugUtils.generateRandomDestinationAround(
      startLat,
      startLng,
      distanceMeters: 7000,
      seed: 123,
    );

    final distance = TrackingDebugUtils.distanceMeters(
      startLat,
      startLng,
      dest.lat.toDouble(),
      dest.lng.toDouble(),
    );

    expect(distance, greaterThan(6500));
    expect(distance, lessThan(7500));
  });
}
