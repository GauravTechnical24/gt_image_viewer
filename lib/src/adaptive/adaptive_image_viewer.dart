import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gt_image_viewer/src/core/image_config_enum.dart';
import 'package:gt_image_viewer/src/core/image_viewer_config.dart';
import 'package:gt_image_viewer/src/cupertino/cupertino_image_viewer.dart';
import 'package:gt_image_viewer/src/material/material_image_viewer.dart';

/// Universal image viewer with platform-adaptive UI support.
///
/// Automatically switches between Cupertino (iOS/macOS) and Material Design styling
/// according to the operating platform or the provided [ImageContainerConfig.designSystem].
class UniversalImageViewer extends StatelessWidget {
  /// Source type of the image (asset or network).
  final ImageSource source;

  /// File path or URL to the image resource.
  final String path;

  /// Container decoration configuration.
  final ImageContainerConfig config;

  /// Custom widget rendered when image loading fails.
  final Widget? errorWidget;

  /// Custom widget rendered while image is loading.
  final Widget? loadingWidget;

  /// Callback invoked when an image loading error occurs.
  final VoidCallback? onError;

  /// Optional HTTP headers sent with network image requests.
  final Map<String, String>? httpHeaders;

  /// Duration of the fade-in animation on successful image load.
  final Duration? fadeInDuration;

  /// Duration of the fade-out animation when replacing placeholder.
  final Duration? fadeOutDuration;

  /// Duration of placeholder fade-in animation.
  final Duration? placeholderFadeInDuration;

  /// Optional maximum height constraint on disk cache storage.
  final int? maxHeightDiskCache;

  /// Optional maximum width constraint on disk cache storage.
  final int? maxWidthDiskCache;

  /// Optional maximum height constraint on decoded memory cache.
  final int? memCacheHeight;

  /// Optional maximum width constraint on decoded memory cache.
  final int? memCacheWidth;

  /// Custom [BaseCacheManager] instance.
  final BaseCacheManager? cacheManager;

  /// Creates a universal platform-adaptive image viewer.
  const UniversalImageViewer({
    super.key,
    required this.source,
    required this.path,
    this.config = const ImageContainerConfig(),
    this.errorWidget,
    this.loadingWidget,
    this.onError,
    this.httpHeaders,
    this.fadeInDuration,
    this.fadeOutDuration,
    this.placeholderFadeInDuration,
    this.maxHeightDiskCache,
    this.maxWidthDiskCache,
    this.memCacheHeight,
    this.memCacheWidth,
    this.cacheManager,
  });

  /// Factory constructor for local asset images.
  factory UniversalImageViewer.asset({
    Key? key,
    required String assetPath,
    ImageContainerConfig config = const ImageContainerConfig(),
    Widget? errorWidget,
    VoidCallback? onError,
  }) {
    return UniversalImageViewer(
      key: key,
      source: ImageSource.asset,
      path: assetPath,
      config: config,
      errorWidget: errorWidget,
      onError: onError,
    );
  }

  /// Factory constructor for cached network images.
  factory UniversalImageViewer.network({
    Key? key,
    required String url,
    ImageContainerConfig config = const ImageContainerConfig(),
    Widget? errorWidget,
    Widget? loadingWidget,
    VoidCallback? onError,
    Map<String, String>? httpHeaders,
    Duration? fadeInDuration,
    Duration? fadeOutDuration,
    Duration? placeholderFadeInDuration,
    int? maxHeightDiskCache,
    int? maxWidthDiskCache,
    int? memCacheHeight,
    int? memCacheWidth,
    BaseCacheManager? cacheManager,
  }) {
    return UniversalImageViewer(
      key: key,
      source: ImageSource.network,
      path: url,
      config: config,
      errorWidget: errorWidget,
      loadingWidget: loadingWidget,
      onError: onError,
      httpHeaders: httpHeaders,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
      placeholderFadeInDuration: placeholderFadeInDuration,
      maxHeightDiskCache: maxHeightDiskCache,
      maxWidthDiskCache: maxWidthDiskCache,
      memCacheHeight: memCacheHeight,
      memCacheWidth: memCacheWidth,
      cacheManager: cacheManager,
    );
  }

  bool _isCupertino() {
    switch (config.designSystem) {
      case ImageDesignSystem.cupertino:
        return true;
      case ImageDesignSystem.material:
        return false;
      case ImageDesignSystem.adaptive:
        return defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCupertino()) {
      return CupertinoImageViewer(
        source: source,
        path: path,
        config: config,
        errorWidget: errorWidget,
        loadingWidget: loadingWidget,
        onError: onError,
        httpHeaders: httpHeaders,
        fadeInDuration: fadeInDuration,
        fadeOutDuration: fadeOutDuration,
        placeholderFadeInDuration: placeholderFadeInDuration,
        maxHeightDiskCache: maxHeightDiskCache,
        maxWidthDiskCache: maxWidthDiskCache,
        memCacheHeight: memCacheHeight,
        memCacheWidth: memCacheWidth,
        cacheManager: cacheManager,
      );
    }

    return MaterialImageViewer(
      source: source,
      path: path,
      config: config,
      errorWidget: errorWidget,
      loadingWidget: loadingWidget,
      onError: onError,
      httpHeaders: httpHeaders,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
      placeholderFadeInDuration: placeholderFadeInDuration,
      maxHeightDiskCache: maxHeightDiskCache,
      maxWidthDiskCache: maxWidthDiskCache,
      memCacheHeight: memCacheHeight,
      memCacheWidth: memCacheWidth,
      cacheManager: cacheManager,
    );
  }
}
