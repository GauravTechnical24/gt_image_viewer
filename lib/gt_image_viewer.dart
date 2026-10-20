/// GT Image Viewer - A universal Flutter image viewer package.
///
/// This package provides:
/// - Cached network image loading with automatic caching
/// - SVG rendering for asset and network sources
/// - Lottie animation support
/// - Material, Cupertino (iOS/macOS), and platform-adaptive UI modes
/// - Configurable container styling (border, shadow, shape, radius)
/// - Circular image support
/// - Custom error and loading widgets
library;

// Core Configuration & Cache
export 'src/core/cache_manager_helper.dart' show CacheManagerHelper;
export 'src/core/image_config_enum.dart' show ImageDesignSystem, ImageSource;
export 'src/core/image_viewer_config.dart' show ImageContainerConfig;

// Adaptive Universal Viewers
export 'src/adaptive/adaptive_image_viewer.dart' show UniversalImageViewer;
export 'src/adaptive/adaptive_lottie_viewer.dart' show UniversalLottieViewer;
export 'src/adaptive/adaptive_svg_viewer.dart' show UniversalSvgViewer;

// Material Design Viewers
export 'src/material/material_image_viewer.dart' show MaterialImageViewer;
export 'src/material/material_lottie_viewer.dart' show MaterialLottieViewer;
export 'src/material/material_svg_viewer.dart' show MaterialSvgViewer;

// Cupertino (iOS/macOS) Viewers
export 'src/cupertino/cupertino_image_viewer.dart' show CupertinoImageViewer;
export 'src/cupertino/cupertino_lottie_viewer.dart' show CupertinoLottieViewer;
export 'src/cupertino/cupertino_svg_viewer.dart' show CupertinoSvgViewer;
