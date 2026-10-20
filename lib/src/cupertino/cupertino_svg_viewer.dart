import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gt_image_viewer/src/core/image_config_enum.dart';
import 'package:gt_image_viewer/src/core/image_container.dart';
import 'package:gt_image_viewer/src/core/image_viewer_config.dart';

/// Cupertino (iOS native style) SVG vector graphics viewer.
class CupertinoSvgViewer extends StatelessWidget {
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

  /// Creates a Cupertino iOS-style SVG viewer.
  const CupertinoSvgViewer({
    super.key,
    required this.path,
    this.config = const ImageContainerConfig(
      designSystem: ImageDesignSystem.cupertino,
    ),
    this.color,
    this.errorWidget,
    this.loadingWidget,
    this.isNetwork = false,
    this.onError,
  });

  /// Factory constructor for local asset SVG graphics with Cupertino styling.
  factory CupertinoSvgViewer.asset({
    Key? key,
    required String svgPath,
    ImageContainerConfig config = const ImageContainerConfig(
      designSystem: ImageDesignSystem.cupertino,
    ),
    Color? color,
    Widget? errorWidget,
    VoidCallback? onError,
  }) {
    return CupertinoSvgViewer(
      key: key,
      path: svgPath,
      config: config,
      color: color,
      errorWidget: errorWidget,
      isNetwork: false,
      onError: onError,
    );
  }

  /// Factory constructor for remote network SVG graphics with Cupertino styling.
  factory CupertinoSvgViewer.network({
    Key? key,
    required String url,
    ImageContainerConfig config = const ImageContainerConfig(
      designSystem: ImageDesignSystem.cupertino,
    ),
    Color? color,
    Widget? errorWidget,
    Widget? loadingWidget,
    VoidCallback? onError,
  }) {
    return CupertinoSvgViewer(
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

  @override
  Widget build(BuildContext context) {
    return ImageContainerWrapper(
      config: config,
      child: isNetwork ? _buildSvgNetwork(context) : _buildSvgAsset(context),
    );
  }

  Widget _buildSvgAsset(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: config.width,
      height: config.height,
      fit: config.fit,
      alignment: config.alignment,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      placeholderBuilder: (context) => loadingWidget ?? _buildLoader(),
      errorBuilder: (context, error, stackTrace) {
        onError?.call();
        return _buildError(context);
      },
    );
  }

  Widget _buildSvgNetwork(BuildContext context) {
    return SvgPicture.network(
      path,
      width: config.width,
      height: config.height,
      fit: config.fit,
      alignment: config.alignment,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      placeholderBuilder: (context) => loadingWidget ?? _buildLoader(),
      errorBuilder: (context, error, stackTrace) {
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
