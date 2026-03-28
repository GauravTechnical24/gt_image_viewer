import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gt_image_viewer/image_handler/cache_manager_helper.dart';
import 'package:gt_image_viewer/image_handler/image_config_enum.dart';
import 'package:gt_image_viewer/image_handler/image_viewer_config.dart';

/// Universal Image Viewer Widget
/// Supports: Asset and Network (with cached_network_image)
class UniversalImageViewer extends StatelessWidget {
  final ImageSource source;
  final String path;
  final ImageContainerConfig config;
  final Widget? errorWidget;
  final Widget? loadingWidget;
  final VoidCallback? onError;
  final Map<String, String>? httpHeaders;
  final Duration? fadeInDuration;
  final Duration? fadeOutDuration;
  final Duration? placeholderFadeInDuration;
  final int? maxHeightDiskCache;
  final int? maxWidthDiskCache;
  final int? memCacheHeight;
  final int? memCacheWidth;
  final BaseCacheManager? cacheManager;

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

  /// Factory constructor for asset images
  factory UniversalImageViewer.asset({
    required String assetPath,
    ImageContainerConfig config = const ImageContainerConfig(),
    Widget? errorWidget,
  }) {
    return UniversalImageViewer(
      source: ImageSource.asset,
      path: assetPath,
      config: config,
      errorWidget: errorWidget,
    );
  }

  /// Factory constructor for network images with cached_network_image
  factory UniversalImageViewer.network({
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
    // Calculate border radius for circular images
    BorderRadius? effectiveBorderRadius = config.borderRadius;

    if (config.isCircle) {
      // Use the smaller dimension to create a perfect circle
      final double? size = config.width != null && config.height != null
          ? (config.width! < config.height! ? config.width : config.height)
          : config.width ?? config.height;

      if (size != null) {
        effectiveBorderRadius = BorderRadius.circular(size / 2);
      } else {
        // Fallback to a large radius if dimensions are not specified
        effectiveBorderRadius = BorderRadius.circular(9999);
      }
    }

    return Container(
      width: config.width,
      height: config.height,
      padding: config.padding,
      margin: config.margin,
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: effectiveBorderRadius,
        border: config.border,
        boxShadow: config.boxShadow,
      ),
      clipBehavior: config.clipBehavior,
      child: _buildImageWidget(),
    );
  }

  Widget _buildImageWidget() {
    switch (source) {
      case ImageSource.asset:
        return _buildAssetImage();
      case ImageSource.network:
        return _buildNetworkImage();
      default:
        return _buildErrorWidget();
    }
  }

  Widget _buildAssetImage() {
    try {
      return Image.asset(
        path,
        width: config.width,
        height: config.height,
        fit: config.fit,
        alignment: config.alignment,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    } catch (e) {
      return _buildErrorWidget();
    }
  }

  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: path,
      width: config.width,
      height: config.height,
      fit: config.fit,
      alignment: config.alignment,
      httpHeaders: httpHeaders,
      // Use provided cacheManager or fallback to the helper's instance
      cacheManager: cacheManager ?? CacheManagerHelper().cacheManager,
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 500),
      fadeOutDuration: fadeOutDuration ?? const Duration(milliseconds: 1000),
      placeholderFadeInDuration:
          placeholderFadeInDuration ?? const Duration(milliseconds: 500),
      maxHeightDiskCache: maxHeightDiskCache,
      maxWidthDiskCache: maxWidthDiskCache,
      memCacheHeight: memCacheHeight,
      memCacheWidth: memCacheWidth,
      placeholder: (context, url) {
        return loadingWidget ?? _buildDefaultLoader(null);
      },
      errorWidget: (context, url, error) {
        onError?.call();
        return _buildErrorWidget();
      },
      // Optional: Use progressIndicatorBuilder for detailed progress
      // progressIndicatorBuilder: (context, url, downloadProgress) {
      //   return _buildDefaultLoader(downloadProgress.progress);
      // },
    );
  }

  Widget _buildDefaultLoader(double? progress) {
    return Center(
      child: progress != null
          ? CircularProgressIndicator(value: progress)
          : const CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget() {
    return errorWidget ??
        const Center(
          child: Icon(Icons.error_outline, color: Colors.red, size: 40),
        );
  }
}
