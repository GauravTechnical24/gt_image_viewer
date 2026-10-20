import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_image_viewer/gt_image_viewer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (MethodCall methodCall) async => '/tmp',
        );
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          null,
        );
  });

  group('ImageContainerConfig', () {
    test('default values are set correctly', () {
      const config = ImageContainerConfig();

      expect(config.width, isNull);
      expect(config.height, isNull);
      expect(config.fit, BoxFit.cover);
      expect(config.isCircle, isFalse);
      expect(config.clipBehavior, Clip.antiAlias);
      expect(config.designSystem, ImageDesignSystem.adaptive);
      expect(config.getEffectiveBorderRadius(), isNull);
    });

    test('custom values are applied', () {
      final config = ImageContainerConfig(
        width: 200,
        height: 150,
        fit: BoxFit.contain,
        isCircle: true,
        borderRadius: BorderRadius.circular(12),
        designSystem: ImageDesignSystem.cupertino,
      );

      expect(config.width, 200);
      expect(config.height, 150);
      expect(config.fit, BoxFit.contain);
      expect(config.isCircle, isTrue);
      expect(config.designSystem, ImageDesignSystem.cupertino);
      expect(config.getEffectiveBorderRadius(), BorderRadius.circular(75));
    });

    test('copyWith updates specified fields', () {
      const original = ImageContainerConfig(width: 100, height: 100);
      final updated = original.copyWith(
        width: 200,
        isCircle: true,
        designSystem: ImageDesignSystem.material,
      );

      expect(updated.width, 200);
      expect(updated.height, 100);
      expect(updated.isCircle, isTrue);
      expect(updated.designSystem, ImageDesignSystem.material);
    });

    test('equality and hashCode contract', () {
      const config1 = ImageContainerConfig(width: 100, height: 100);
      const config2 = ImageContainerConfig(width: 100, height: 100);
      const config3 = ImageContainerConfig(width: 200, height: 100);

      expect(config1, equals(config2));
      expect(config1.hashCode, equals(config2.hashCode));
      expect(config1, isNot(equals(config3)));
      expect(config1.toString(), contains('ImageContainerConfig'));
    });
  });

  group('Enums', () {
    test('ImageSource enum values exist', () {
      expect(ImageSource.values.length, 6);
      expect(ImageSource.values, contains(ImageSource.asset));
      expect(ImageSource.values, contains(ImageSource.network));
      expect(ImageSource.values, contains(ImageSource.svgAsset));
      expect(ImageSource.values, contains(ImageSource.svgNetwork));
      expect(ImageSource.values, contains(ImageSource.lottieAsset));
      expect(ImageSource.values, contains(ImageSource.lottieNetwork));
    });

    test('ImageDesignSystem enum values exist', () {
      expect(ImageDesignSystem.values.length, 3);
      expect(ImageDesignSystem.values, contains(ImageDesignSystem.adaptive));
      expect(ImageDesignSystem.values, contains(ImageDesignSystem.material));
      expect(ImageDesignSystem.values, contains(ImageDesignSystem.cupertino));
    });
  });

  group('CacheManagerHelper', () {
    test('instance returns singleton', () {
      final helper1 = CacheManagerHelper();
      final helper2 = CacheManagerHelper();

      expect(helper1, same(helper2));
    });

    test('resetForTesting clears configuration cleanly', () {
      final helper = CacheManagerHelper();
      helper.initialize(
        cacheKey: 'test_key',
        stalePeriod: const Duration(days: 1),
        maxNrOfCacheObjects: 10,
      );
      helper.resetForTesting();
      expect(CacheManagerHelper.defaultCacheKey, 'customCacheKey');
    });
  });

  group('UniversalImageViewer Widget', () {
    testWidgets('asset factory creates widget correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UniversalImageViewer.asset(assetPath: 'assets/test.png'),
          ),
        ),
      );

      expect(find.byType(UniversalImageViewer), findsOneWidget);
    });

    testWidgets('network factory creates widget correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UniversalImageViewer.network(
              url: 'https://example.com/test.png',
            ),
          ),
        ),
      );

      expect(find.byType(UniversalImageViewer), findsOneWidget);
    });
  });

  group('MaterialImageViewer Widget', () {
    testWidgets('renders MaterialImageViewer correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MaterialImageViewer.asset(assetPath: 'assets/material.png'),
          ),
        ),
      );

      expect(find.byType(MaterialImageViewer), findsOneWidget);
    });
  });

  group('CupertinoImageViewer Widget', () {
    testWidgets('renders CupertinoImageViewer correctly', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: CupertinoPageScaffold(
            child: CupertinoImageViewer.asset(
              assetPath: 'assets/cupertino.png',
            ),
          ),
        ),
      );

      expect(find.byType(CupertinoImageViewer), findsOneWidget);
    });
  });

  group('SVG Viewers', () {
    testWidgets('UniversalSvgViewer asset constructor instantiates', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UniversalSvgViewer.asset(svgPath: 'assets/test.svg'),
          ),
        ),
      );

      expect(find.byType(UniversalSvgViewer), findsOneWidget);
    });

    testWidgets('MaterialSvgViewer asset constructor instantiates', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MaterialSvgViewer.asset(svgPath: 'assets/test.svg'),
          ),
        ),
      );

      expect(find.byType(MaterialSvgViewer), findsOneWidget);
    });

    testWidgets('CupertinoSvgViewer asset constructor instantiates', (
      tester,
    ) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: CupertinoPageScaffold(
            child: CupertinoSvgViewer.asset(svgPath: 'assets/test.svg'),
          ),
        ),
      );

      expect(find.byType(CupertinoSvgViewer), findsOneWidget);
    });
  });

  group('Lottie Viewers', () {
    testWidgets('UniversalLottieViewer asset constructor instantiates', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UniversalLottieViewer.asset(lottiePath: 'assets/test.json'),
          ),
        ),
      );

      expect(find.byType(UniversalLottieViewer), findsOneWidget);
    });

    testWidgets('MaterialLottieViewer asset constructor instantiates', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MaterialLottieViewer.asset(lottiePath: 'assets/test.json'),
          ),
        ),
      );

      expect(find.byType(MaterialLottieViewer), findsOneWidget);
    });

    testWidgets('CupertinoLottieViewer asset constructor instantiates', (
      tester,
    ) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: CupertinoPageScaffold(
            child: CupertinoLottieViewer.asset(lottiePath: 'assets/test.json'),
          ),
        ),
      );

      expect(find.byType(CupertinoLottieViewer), findsOneWidget);
    });
  });
}
