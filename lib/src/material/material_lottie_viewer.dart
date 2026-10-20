import 'package:flutter/material.dart';
import 'package:gt_image_viewer/src/core/image_config_enum.dart';
import 'package:gt_image_viewer/src/core/image_container.dart';
import 'package:gt_image_viewer/src/core/image_viewer_config.dart';
import 'package:lottie/lottie.dart';

/// Material Design Lottie animation viewer.
class MaterialLottieViewer extends StatelessWidget {
  /// File path or URL to the Lottie JSON/ZIP resource.
  final String path;

  /// Container decoration configuration.
  final ImageContainerConfig config;

  /// Whether the animation plays in an infinite loop. Defaults to true.
  final bool repeat;

  /// Whether the animation plays in reverse.
  final bool? reverse;

  /// Optional custom animation controller.
  final AnimationController? controller;

  /// Custom widget rendered when loading fails.
  final Widget? errorWidget;

  /// Custom widget rendered while animation is loading.
  final Widget? loadingWidget;

  /// Whether the path points to a network URL.
  final bool isNetwork;

  /// Optional callback invoked on loading or decoding error.
  final VoidCallback? onError;

  /// Creates a Material Design Lottie viewer.
  const MaterialLottieViewer({
    super.key,
    required this.path,
    this.config = const ImageContainerConfig(
      designSystem: ImageDesignSystem.material,
    ),
    this.repeat = true,
    this.reverse,
    this.controller,
    this.errorWidget,
    this.loadingWidget,
    this.isNetwork = false,
    this.onError,
  });

  /// Factory constructor for local asset Lottie animations with Material styling.
  factory MaterialLottieViewer.asset({
    Key? key,
    required String lottiePath,
    ImageContainerConfig config = const ImageContainerConfig(
      designSystem: ImageDesignSystem.material,
    ),
    bool repeat = true,
    bool? reverse,
    AnimationController? controller,
    Widget? errorWidget,
    VoidCallback? onError,
  }) {
    return MaterialLottieViewer(
      key: key,
      path: lottiePath,
      config: config,
      repeat: repeat,
      reverse: reverse,
      controller: controller,
      errorWidget: errorWidget,
      isNetwork: false,
      onError: onError,
    );
  }

  /// Factory constructor for remote network Lottie animations with Material styling.
  factory MaterialLottieViewer.network({
    Key? key,
    required String url,
    ImageContainerConfig config = const ImageContainerConfig(
      designSystem: ImageDesignSystem.material,
    ),
    bool repeat = true,
    bool? reverse,
    AnimationController? controller,
    Widget? errorWidget,
    Widget? loadingWidget,
    VoidCallback? onError,
  }) {
    return MaterialLottieViewer(
      key: key,
      path: url,
      config: config,
      repeat: repeat,
      reverse: reverse,
      controller: controller,
      errorWidget: errorWidget,
      loadingWidget: loadingWidget,
      isNetwork: true,
      onError: onError,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ImageContainerWrapper(
      config: config,
      child: isNetwork
          ? _buildLottieNetwork(context)
          : _buildLottieAsset(context),
    );
  }

  Widget _buildLottieAsset(BuildContext context) {
    return Lottie.asset(
      path,
      width: config.width,
      height: config.height,
      fit: config.fit,
      alignment: config.alignment,
      repeat: repeat,
      reverse: reverse,
      controller: controller,
      errorBuilder: (context, error, stackTrace) {
        onError?.call();
        return _buildError(context);
      },
      frameBuilder: (context, child, composition) {
        if (composition == null && loadingWidget != null) {
          return loadingWidget!;
        }
        return child;
      },
    );
  }

  Widget _buildLottieNetwork(BuildContext context) {
    return Lottie.network(
      path,
      width: config.width,
      height: config.height,
      fit: config.fit,
      alignment: config.alignment,
      repeat: repeat,
      reverse: reverse,
      controller: controller,
      errorBuilder: (context, error, stackTrace) {
        onError?.call();
        return _buildError(context);
      },
      frameBuilder: (context, child, composition) {
        if (composition == null && loadingWidget != null) {
          return loadingWidget!;
        }
        return child;
      },
    );
  }

  Widget _buildError(BuildContext context) {
    if (errorWidget != null) return errorWidget!;
    final errorColor = Theme.of(context).colorScheme.error;
    return Center(
      child: Icon(Icons.error_outline, color: errorColor, size: 40),
    );
  }
}
