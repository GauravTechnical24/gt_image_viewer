import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_image_viewer/gt_image_viewer.dart';

void main() {
  group('ImageContainerConfig', () {
    test('default values are set correctly', () {
      const config = ImageContainerConfig();

      expect(config.width, isNull);
      expect(config.height, isNull);
      expect(config.fit, BoxFit.cover);
      expect(config.isCircle, isFalse);
      expect(config.clipBehavior, Clip.antiAlias);
    });

    test('custom values are applied', () {
      final config = ImageContainerConfig(
        width: 200,
        height: 150,
        fit: BoxFit.contain,
        isCircle: true,
        borderRadius: BorderRadius.circular(12),
      );

      expect(config.width, 200);
      expect(config.height, 150);
      expect(config.fit, BoxFit.contain);
      expect(config.isCircle, isTrue);
    });
  });

  group('ImageSource', () {
    test('enum values exist', () {
      expect(ImageSource.values.length, greaterThanOrEqualTo(2));
      expect(ImageSource.values.contains(ImageSource.asset), isTrue);
      expect(ImageSource.values.contains(ImageSource.network), isTrue);
    });
  });

  group('CacheManagerHelper', () {
    test('instance returns singleton', () {
      final helper1 = CacheManagerHelper();
      final helper2 = CacheManagerHelper();

      expect(helper1, same(helper2));
    });

    // Note: cacheManager test skipped - requires native platform
  });

  group('UniversalImageViewer Widget', () {
    testWidgets('asset factory creates widget correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UniversalImageViewer(
              source: ImageSource.asset,
              path: 'assets/test.png',
            ),
          ),
        ),
      );

      expect(find.byType(UniversalImageViewer), findsOneWidget);
    });
  });
}
