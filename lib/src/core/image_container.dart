import 'package:flutter/widgets.dart';
import 'package:gt_image_viewer/src/core/image_viewer_config.dart';

/// Reusable decorated container widget wrapping image viewers.
class ImageContainerWrapper extends StatelessWidget {
  /// The image viewer content widget to display within the container.
  final Widget child;

  /// The container configuration defining styling, sizing, and borders.
  final ImageContainerConfig config;

  /// Creates a styled container wrapper around an image widget.
  const ImageContainerWrapper({
    super.key,
    required this.child,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: config.width,
      height: config.height,
      padding: config.padding,
      margin: config.margin,
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: config.getEffectiveBorderRadius(),
        border: config.border,
        boxShadow: config.boxShadow,
      ),
      clipBehavior: config.clipBehavior,
      child: child,
    );
  }
}
