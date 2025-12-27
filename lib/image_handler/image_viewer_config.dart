import 'package:flutter/material.dart';

/// Configuration class for image container decoration
class ImageContainerConfig {
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxFit fit;
  final Alignment alignment;
  final Clip clipBehavior;
  final bool isCircle;

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
  });

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
    );
  }
}
