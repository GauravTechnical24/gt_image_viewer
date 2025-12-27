# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2025-12-27

### Added
- `UniversalImageViewer` - Universal image widget
  - Asset image support
  - Network image with caching (cached_network_image)
  - Configurable fade animations
  - Custom HTTP headers support
  - Memory and disk cache control
- `UniversalSvgViewer` - SVG image widget
  - Asset SVG support
  - Network SVG support
  - Color tinting via ColorFilter
- `UniversalLottieViewer` - Lottie animation widget
  - Asset animation support
  - Network animation support
  - Animation controller access
  - Repeat and reverse options
- `ImageContainerConfig` - Shared configuration
  - Width, height, fit, alignment
  - Circular image support
  - Border radius, border, box shadow
  - Padding, margin, clip behavior
- `CacheManagerHelper` - Cache management utility
  - Singleton cache manager
  - Cache clearing methods
  - Individual file removal
