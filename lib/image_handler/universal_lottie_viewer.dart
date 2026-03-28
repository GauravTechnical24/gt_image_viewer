import 'package:flutter/material.dart';
import 'package:gt_image_viewer/image_handler/image_viewer_config.dart';
import 'package:lottie/lottie.dart';

/// Universal Lottie Viewer Widget
/// Supports: Asset and Network Lottie animations
class UniversalLottieViewer extends StatelessWidget {
  final String path;
  final ImageContainerConfig config;
  final bool repeat;
  final Widget? errorWidget;
  final Widget? loadingWidget;
  final bool isNetwork;

  const UniversalLottieViewer({
    super.key,
    required this.path,
    this.config = const ImageContainerConfig(),
    this.repeat = true,
    this.errorWidget,
    this.loadingWidget,
    this.isNetwork = false,
  });

  /// Factory constructor for asset Lottie
  factory UniversalLottieViewer.asset({
    required String lottiePath,
    ImageContainerConfig config = const ImageContainerConfig(),
    bool repeat = true,
    Widget? errorWidget,
  }) {
    return UniversalLottieViewer(
      path: lottiePath,
      config: config,
      repeat: repeat,
      errorWidget: errorWidget,
      isNetwork: false,
    );
  }

  /// Factory constructor for network Lottie
  factory UniversalLottieViewer.network({
    required String url,
    ImageContainerConfig config = const ImageContainerConfig(),
    bool repeat = true,
    Widget? errorWidget,
    Widget? loadingWidget,
  }) {
    return UniversalLottieViewer(
      path: url,
      config: config,
      repeat: repeat,
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
      child: isNetwork ? _buildLottieNetwork() : _buildLottieAsset(),
    );
  }

  Widget _buildLottieAsset() {
    return Lottie.asset(
      path,
      width: config.width,
      height: config.height,
      fit: config.fit,
      alignment: config.alignment,
      repeat: repeat,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorWidget();
      },
    );
  }

  Widget _buildLottieNetwork() {
    return Lottie.network(
      path,
      width: config.width,
      height: config.height,
      fit: config.fit,
      alignment: config.alignment,
      repeat: repeat,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorWidget();
      },
    );
  }

  Widget _buildErrorWidget() {
    return errorWidget ??
        const Center(
          child: Icon(Icons.error_outline, color: Colors.red, size: 40),
        );
  }
}
