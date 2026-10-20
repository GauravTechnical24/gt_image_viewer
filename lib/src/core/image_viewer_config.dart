import 'package:flutter/widgets.dart';
import 'package:gt_image_viewer/src/core/image_config_enum.dart';

/// Configuration options for the outer container wrapping the image viewer.
///
/// Controls dimensions, borders, clipping, circular shape, shadows,
/// background colors, and design system adaptation.
@immutable
class ImageContainerConfig {
  /// Width of the outer image container. If null, sizes to child or parent constraint.
  final double? width;

  /// Height of the outer image container. If null, sizes to child or parent constraint.
  final double? height;

  /// Background color fill behind the image.
  final Color? backgroundColor;

  /// Border radius applied to the container. Ignored if [isCircle] is true.
  final BorderRadius? borderRadius;

  /// Optional border rendered around the image container.
  final Border? border;

  /// List of shadows cast by the container.
  final List<BoxShadow>? boxShadow;

  /// Internal padding inside the container surrounding the image.
  final EdgeInsetsGeometry? padding;

  /// External margin around the container.
  final EdgeInsetsGeometry? margin;

  /// How the image should be inscribed into the container. Defaults to [BoxFit.cover].
  final BoxFit fit;

  /// Alignment of the image within its bounds. Defaults to [Alignment.center].
  final Alignment alignment;

  /// Clip behavior applied to the container. Defaults to [Clip.antiAlias].
  final Clip clipBehavior;

  /// Whether the image container is forced into a circular shape.
  ///
  /// When true, [borderRadius] is automatically calculated to form a circle.
  final bool isCircle;

  /// Design system style used for indicators and fallback widgets.
  ///
  /// Defaults to [ImageDesignSystem.adaptive].
  final ImageDesignSystem designSystem;

  /// Creates a configuration for image container styling and behavior.
  const ImageContainerConfig({
    this.width,
    this.height,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.padding,
    this.margin,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.clipBehavior = Clip.antiAlias,
    this.isCircle = false,
    this.designSystem = ImageDesignSystem.adaptive,
  });

  /// Creates a copy of this configuration with the given fields replaced by new values.
  ImageContainerConfig copyWith({
    double? width,
    double? height,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    Border? border,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxFit? fit,
    Alignment? alignment,
    Clip? clipBehavior,
    bool? isCircle,
    ImageDesignSystem? designSystem,
  }) {
    return ImageContainerConfig(
      width: width ?? this.width,
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      border: border ?? this.border,
      boxShadow: boxShadow ?? this.boxShadow,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      fit: fit ?? this.fit,
      alignment: alignment ?? this.alignment,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      isCircle: isCircle ?? this.isCircle,
      designSystem: designSystem ?? this.designSystem,
    );
  }

  /// Calculates the effective border radius, factoring in [isCircle].
  BorderRadius? getEffectiveBorderRadius() {
    if (!isCircle) return borderRadius;

    final double? size = width != null && height != null
        ? (width! < height! ? width : height)
        : width ?? height;

    if (size != null) {
      return BorderRadius.circular(size / 2);
    }
    return BorderRadius.circular(9999);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImageContainerConfig &&
        other.width == width &&
        other.height == height &&
        other.backgroundColor == backgroundColor &&
        other.borderRadius == borderRadius &&
        other.border == border &&
        _listEquals(other.boxShadow, boxShadow) &&
        other.padding == padding &&
        other.margin == margin &&
        other.fit == fit &&
        other.alignment == alignment &&
        other.clipBehavior == clipBehavior &&
        other.isCircle == isCircle &&
        other.designSystem == designSystem;
  }

  @override
  int get hashCode => Object.hash(
    width,
    height,
    backgroundColor,
    borderRadius,
    border,
    boxShadow == null ? null : Object.hashAll(boxShadow!),
    padding,
    margin,
    fit,
    alignment,
    clipBehavior,
    isCircle,
    designSystem,
  );

  @override
  String toString() {
    return 'ImageContainerConfig('
        'width: $width, '
        'height: $height, '
        'fit: $fit, '
        'isCircle: $isCircle, '
        'designSystem: $designSystem)';
  }

  static bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}
