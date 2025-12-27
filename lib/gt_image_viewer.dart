/// GT Image Viewer - A universal Flutter image viewer package.
///
/// This package provides:
/// - Cached network image loading with automatic caching
/// - SVG rendering for asset and network sources
/// - Lottie animation support
/// - Configurable container styling (border, shadow, shape)
/// - Circular image support
/// - Custom error and loading widgets
library;

// Universal Viewers
export 'image_handler/universal_image_viewer.dart' show UniversalImageViewer;
export 'image_handler/universal_svg_viewer.dart' show UniversalSvgViewer;
export 'image_handler/universal_lottie_viewer.dart' show UniversalLottieViewer;

// Configuration
export 'image_handler/image_viewer_config.dart' show ImageContainerConfig;
export 'image_handler/image_config_enum.dart' show ImageSource;

// Cache Management
export 'image_handler/cache_manager_helper.dart' show CacheManagerHelper;
