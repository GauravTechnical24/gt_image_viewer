# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2026-03-28

### Changed
- **Flutter/Dart SDK Upgrade**: Upgraded to Flutter 3.41.0 and Dart 3.11.0.
- **Improved Image Scaling**: Updated `UniversalImageViewer`, `UniversalSvgViewer`, and `UniversalLottieViewer` to explicitly pass dimensions to underlying rendering widgets. This fixes issues where images would not scale correctly when reducing size in constrained containers (e.g., AppBars, profile headers).

### Fixed
- Image resizing bug where images did not respect `width` and `height` from `ImageContainerConfig` correctly in some layouts.

### Added
- Explicit `width` and `height` properties passed to `Image`, `CachedNetworkImage`, `SvgPicture`, and `Lottie` widgets.

## [1.0.0] - 2025-12-27

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
