import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gt_image_viewer/src/core/cache_manager_helper.dart';
import 'package:gt_image_viewer/src/core/image_config_enum.dart';
import 'package:gt_image_viewer/src/core/image_container.dart';
import 'package:gt_image_viewer/src/core/image_viewer_config.dart';

/// Cupertino (iOS/macOS native style) image viewer component.
///
/// Implements iOS design language with [CupertinoActivityIndicator] loading spinners
/// and [CupertinoIcons.exclamationmark_circle] error fallbacks.
class CupertinoImageViewer extends StatelessWidget {
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

  /// Custom [BaseCacheManager] instance. If null, uses [CacheManagerHelper.instance].
  final BaseCacheManager? cacheManager;

  /// Creates a Cupertino iOS-style image viewer.
  const CupertinoImageViewer({
    super.key,
    required this.source,
    required this.path,
    this.config = const ImageContainerConfig(
      designSystem: ImageDesignSystem.cupertino,
    ),
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

  /// Factory constructor for asset images with Cupertino iOS styling.
  factory CupertinoImageViewer.asset({
    Key? key,
    required String assetPath,
    ImageContainerConfig config = const ImageContainerConfig(
      designSystem: ImageDesignSystem.cupertino,
    ),
    Widget? errorWidget,
    VoidCallback? onError,
  }) {
    return CupertinoImageViewer(
      key: key,
      source: ImageSource.asset,
      path: assetPath,
      config: config,
      errorWidget: errorWidget,
      onError: onError,
    );
  }

  /// Factory constructor for network images with caching and Cupertino iOS styling.
  factory CupertinoImageViewer.network({
    Key? key,
    required String url,
    ImageContainerConfig config = const ImageContainerConfig(
      designSystem: ImageDesignSystem.cupertino,
    ),
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
    return CupertinoImageViewer(
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

  @override
  Widget build(BuildContext context) {
    return ImageContainerWrapper(config: config, child: _buildImage(context));
  }

  Widget _buildImage(BuildContext context) {
    switch (source) {
      case ImageSource.asset:
        return _buildAsset(context);
      case ImageSource.network:
        return _buildNetwork(context);
      default:
        return _buildError(context);
    }
  }

  Widget _buildAsset(BuildContext context) {
    return Image.asset(
      path,
      width: config.width,
      height: config.height,
      fit: config.fit,
      alignment: config.alignment,
      errorBuilder: (context, error, stackTrace) {
        onError?.call();
        return _buildError(context);
      },
    );
  }

  Widget _buildNetwork(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: path,
      width: config.width,
      height: config.height,
      fit: config.fit,
      alignment: config.alignment,
      httpHeaders: httpHeaders,
      cacheManager: cacheManager ?? CacheManagerHelper().cacheManager,
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 400),
      fadeOutDuration: fadeOutDuration ?? const Duration(milliseconds: 600),
      placeholderFadeInDuration:
          placeholderFadeInDuration ?? const Duration(milliseconds: 300),
      maxHeightDiskCache: maxHeightDiskCache,
      maxWidthDiskCache: maxWidthDiskCache,
      memCacheHeight: memCacheHeight,
      memCacheWidth: memCacheWidth,
      placeholder: (context, url) {
        return loadingWidget ?? _buildLoader();
      },
      errorWidget: (context, url, error) {
        onError?.call();
        return _buildError(context);
      },
    );
  }

  Widget _buildLoader() {
    return const Center(child: CupertinoActivityIndicator());
  }

  Widget _buildError(BuildContext context) {
    if (errorWidget != null) return errorWidget!;
    return const Center(
      child: Icon(
        CupertinoIcons.exclamationmark_circle,
        color: CupertinoColors.systemRed,
        size: 36,
      ),
    );
  }
}
