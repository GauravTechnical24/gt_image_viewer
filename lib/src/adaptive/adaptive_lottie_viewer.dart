import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gt_image_viewer/src/core/image_config_enum.dart';
import 'package:gt_image_viewer/src/core/image_viewer_config.dart';
import 'package:gt_image_viewer/src/cupertino/cupertino_lottie_viewer.dart';
import 'package:gt_image_viewer/src/material/material_lottie_viewer.dart';

/// Universal Lottie animation viewer with platform-adaptive UI support.
class UniversalLottieViewer extends StatelessWidget {
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

  /// Creates a universal platform-adaptive Lottie viewer.
  const UniversalLottieViewer({
    super.key,
    required this.path,
    this.config = const ImageContainerConfig(),
    this.repeat = true,
    this.reverse,
    this.controller,
    this.errorWidget,
    this.loadingWidget,
    this.isNetwork = false,
    this.onError,
  });

  /// Factory constructor for local asset Lottie animations.
  factory UniversalLottieViewer.asset({
    Key? key,
    required String lottiePath,
    ImageContainerConfig config = const ImageContainerConfig(),
    bool repeat = true,
    bool? reverse,
    AnimationController? controller,
    Widget? errorWidget,
    VoidCallback? onError,
  }) {
    return UniversalLottieViewer(
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

  /// Factory constructor for remote network Lottie animations.
  factory UniversalLottieViewer.network({
    Key? key,
    required String url,
    ImageContainerConfig config = const ImageContainerConfig(),
    bool repeat = true,
    bool? reverse,
    AnimationController? controller,
    Widget? errorWidget,
    Widget? loadingWidget,
    VoidCallback? onError,
  }) {
    return UniversalLottieViewer(
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
      return CupertinoLottieViewer(
        path: path,
        config: config,
        repeat: repeat,
        reverse: reverse,
        controller: controller,
        errorWidget: errorWidget,
        loadingWidget: loadingWidget,
        isNetwork: isNetwork,
        onError: onError,
      );
    }

    return MaterialLottieViewer(
      path: path,
      config: config,
      repeat: repeat,
      reverse: reverse,
      controller: controller,
      errorWidget: errorWidget,
      loadingWidget: loadingWidget,
      isNetwork: isNetwork,
      onError: onError,
    );
  }
}
