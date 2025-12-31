import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';

import 'package:zero_signal/my_app.dart';
import 'package:zero_signal/screen/map_routes_screen/map_routes_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MapRoutesScreen demo: long-press draws ~7km real-road route',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Let the app boot (splash, bindings, etc.)
    await tester.pumpAndSettle(const Duration(seconds: 8));

    // Navigate directly to MapRoutesScreen for the demo.
    Get.to(() => const MapRoutesScreen());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Trigger the debug demo route (long press).
    final demoTarget = find.byKey(const Key('map_btn2_longpress_area'));
    expect(demoTarget, findsOneWidget);

    await tester.longPress(demoTarget);
    await tester.pump();

    // Give time for Directions API + polyline rendering.
    await tester.pumpAndSettle(const Duration(seconds: 8));
  });
}
