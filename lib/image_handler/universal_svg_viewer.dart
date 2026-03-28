import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gt_image_viewer/image_handler/image_viewer_config.dart';

/// Universal SVG Viewer Widget
/// Supports: Asset and Network SVG images
class UniversalSvgViewer extends StatelessWidget {
  final String path;
  final ImageContainerConfig config;
  final Color? color;
  final Widget? errorWidget;
  final Widget? loadingWidget;
  final bool isNetwork;

  const UniversalSvgViewer({
    super.key,
    required this.path,
    this.config = const ImageContainerConfig(),
    this.color,
    this.errorWidget,
    this.loadingWidget,
    this.isNetwork = false,
  });

  /// Factory constructor for asset SVGs
  factory UniversalSvgViewer.asset({
    required String svgPath,
    ImageContainerConfig config = const ImageContainerConfig(),
    Color? color,
    Widget? errorWidget,
  }) {
    return UniversalSvgViewer(
      path: svgPath,
      config: config,
      color: color,
      errorWidget: errorWidget,
      isNetwork: false,
    );
  }

  /// Factory constructor for network SVGs
  factory UniversalSvgViewer.network({
    required String url,
    ImageContainerConfig config = const ImageContainerConfig(),
    Color? color,
    Widget? errorWidget,
    Widget? loadingWidget,
  }) {
    return UniversalSvgViewer(
      path: url,
      config: config,
      color: color,
      errorWidget: errorWidget,
      loadingWidget: loadingWidget,
      isNetwork: true,
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
      child: isNetwork ? _buildSvgNetwork() : _buildSvgAsset(),
    );
  }

  Widget _buildSvgAsset() {
    return SvgPicture.asset(
      path,
      width: config.width,
      height: config.height,
      fit: config.fit,
      alignment: config.alignment,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      placeholderBuilder: (context) =>
          loadingWidget ?? _buildDefaultLoader(null),
    );
  }

  Widget _buildSvgNetwork() {
    return SvgPicture.network(
      path,
      width: config.width,
      height: config.height,
      fit: config.fit,
      alignment: config.alignment,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      placeholderBuilder: (context) =>
          loadingWidget ?? _buildDefaultLoader(null),
    );
  }

  Widget _buildDefaultLoader(double? progress) {
    return Center(
      child: progress != null
          ? CircularProgressIndicator(value: progress)
          : const CircularProgressIndicator(),
    );
  }
}
