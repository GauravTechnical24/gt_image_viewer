/// Defines the supported source types for image, SVG, and Lottie assets.
enum ImageSource {
  /// Local asset image loaded via Flutter's asset bundle.
  asset,

  /// Remote network image loaded and cached over HTTP/HTTPS.
  network,

  /// Local vector graphic loaded from the asset bundle.
  svgAsset,

  /// Remote vector graphic loaded from a network URL.
  svgNetwork,

  /// Local Lottie animation loaded from the asset bundle.
  lottieAsset,

  /// Remote Lottie animation loaded from a network URL.
  lottieNetwork,
}

/// Defines the design system used for rendering loading spinners,
/// icons, and fallback UI across platforms.
enum ImageDesignSystem {
  /// Automatically uses Cupertino widgets on iOS/macOS and Material Design on other platforms.
  adaptive,

  /// Explicitly renders Material Design widgets (e.g., [CircularProgressIndicator], [Icons.error_outline]).
  material,

  /// Explicitly renders iOS-style Cupertino widgets (e.g., [CupertinoActivityIndicator], [CupertinoIcons.exclamationmark_circle]).
  cupertino,
}
