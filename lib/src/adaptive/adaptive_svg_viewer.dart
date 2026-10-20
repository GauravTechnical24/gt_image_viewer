import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:gt_image_viewer/src/core/image_config_enum.dart';
import 'package:gt_image_viewer/src/core/image_viewer_config.dart';
import 'package:gt_image_viewer/src/cupertino/cupertino_svg_viewer.dart';
import 'package:gt_image_viewer/src/material/material_svg_viewer.dart';

/// Universal SVG vector graphics viewer with platform-adaptive UI support.
class UniversalSvgViewer extends StatelessWidget {
  /// File path or URL to the SVG asset.
  final String path;

  /// Container decoration configuration.
  final ImageContainerConfig config;

  /// Optional tint color applied to the SVG graphic.
  final Color? color;

  /// Custom widget rendered when SVG loading fails.
  final Widget? errorWidget;

  /// Custom widget rendered while SVG is loading.
  final Widget? loadingWidget;

  /// Whether the SVG path points to a remote network resource.
  final bool isNetwork;

  /// Optional callback invoked on loading or decoding error.
  final VoidCallback? onError;

  /// Creates a universal platform-adaptive SVG viewer.
  const UniversalSvgViewer({
    super.key,
    required this.path,
    this.config = const ImageContainerConfig(),
    this.color,
    this.errorWidget,
    this.loadingWidget,
    this.isNetwork = false,
    this.onError,
  });

  /// Factory constructor for local asset SVG graphics.
  factory UniversalSvgViewer.asset({
    Key? key,
    required String svgPath,
    ImageContainerConfig config = const ImageContainerConfig(),
    Color? color,
    Widget? errorWidget,
    VoidCallback? onError,
  }) {
    return UniversalSvgViewer(
      key: key,
      path: svgPath,
      config: config,
      color: color,
      errorWidget: errorWidget,
      isNetwork: false,
      onError: onError,
    );
  }

  /// Factory constructor for remote network SVG graphics.
  factory UniversalSvgViewer.network({
    Key? key,
    required String url,
    ImageContainerConfig config = const ImageContainerConfig(),
    Color? color,
    Widget? errorWidget,
    Widget? loadingWidget,
    VoidCallback? onError,
  }) {
    return UniversalSvgViewer(
      key: key,
      path: url,
      config: config,
      color: color,
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
      return CupertinoSvgViewer(
        path: path,
        config: config,
        color: color,
        errorWidget: errorWidget,
        loadingWidget: loadingWidget,
        isNetwork: isNetwork,
        onError: onError,
      );
    }

    return MaterialSvgViewer(
      path: path,
      config: config,
      color: color,
      errorWidget: errorWidget,
      loadingWidget: loadingWidget,
      isNetwork: isNetwork,
      onError: onError,
    );
  }
}
