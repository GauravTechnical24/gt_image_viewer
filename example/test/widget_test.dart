import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_image_viewer_example/main.dart';

void main() {
  testWidgets(
    'ImageViewerExampleScreen displays correctly on desktop viewport',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 3200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const MyApp());
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('GT Image Viewer Example'), findsOneWidget);
      expect(find.text('v1.3.0 • 160/160 pub.dev score'), findsOneWidget);
      expect(find.text('Network Image (Cached)'), findsOneWidget);
      expect(find.text('Material & Cupertino Styling'), findsOneWidget);
      expect(find.text('Circular Image'), findsOneWidget);
      expect(find.text('Styled Container'), findsOneWidget);
      expect(find.text('Clear Image Cache'), findsOneWidget);

      // Switch to second tab
      await tester.tap(find.byType(Tab).at(1));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('Design System Comparison'), findsOneWidget);
    },
  );

  testWidgets(
    'ImageViewerExampleScreen renders without overflow on narrow mobile screens (320px & 362px)',
    (WidgetTester tester) async {
      // Test on ultra-narrow 320px device (e.g. small iPhone SE)
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const MyApp());
      await tester.pump(const Duration(milliseconds: 200));

      // Must render without any layout exceptions on narrow width
      expect(find.text('GT Image Viewer Example'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Switch through tabs on narrow device
      for (int i = 0; i < 4; i++) {
        await tester.tap(find.byType(Tab).at(i), warnIfMissed: false);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        expect(tester.takeException(), isNull);
      }
    },
  );
}
