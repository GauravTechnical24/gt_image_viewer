# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] - 2026-10-20

### Added
- **Cupertino UI Support**: Added dedicated `CupertinoImageViewer`, `CupertinoSvgViewer`, and `CupertinoLottieViewer` widgets implementing native iOS/macOS styling with `CupertinoActivityIndicator` and `CupertinoIcons`.
- **Material UI Support**: Added dedicated `MaterialImageViewer`, `MaterialSvgViewer`, and `MaterialLottieViewer` widgets implementing Material Design styling with `CircularProgressIndicator`.
- **Platform-Adaptive Mode**: `UniversalImageViewer`, `UniversalSvgViewer`, and `UniversalLottieViewer` automatically adapt to Cupertino on iOS/macOS and Material on Android/other platforms.
- **Design System Configuration**: Added `ImageDesignSystem` enum (`adaptive`, `material`, `cupertino`) to `ImageContainerConfig`.
- **Equality & Serialization**: Added `operator ==`, `hashCode`, and `toString()` implementations to `ImageContainerConfig`.
- **Cache Helper Enhancements**: Added `clearCache()`, `removeFile()`, and `resetForTesting()` methods to `CacheManagerHelper`.
- **Expanded Test Suite**: Comprehensive unit and widget tests for Material, Cupertino, Adaptive, configuration, and caching behavior.

### Changed
- **SDK Compatibility Upgrade**: Targeted Flutter `3.47.7` and Dart `3.13.5` (minimum constraints `sdk: ^3.13.0`, `flutter: ">=3.47.0"`).
- **Dependency Upgrades**:
  - `cached_network_image` upgraded to `^4.0.4`.
  - `flutter_cache_manager` upgraded to `^3.4.5`.
  - `lottie` upgraded to `^3.6.1`.
  - `flutter_svg` upgraded to `^2.3.0`.
  - `cupertino_icons` in example app upgraded to `^2.0.0`.
- **Architecture Modularization**: Reorganized internal architecture into `src/core/`, `src/material/`, `src/cupertino/`, and `src/adaptive/` while preserving backward-compatible re-exports in `lib/image_handler/`.
- **Documentation**: 100% dartdoc coverage across all public libraries, classes, constructors, methods, and enums.

### Fixed
- Fixed documentation examples in `README.md` for `CacheManagerHelper` method calls.
- Resolved pub.dev dependency constraint score deduction by supporting `cached_network_image` 4.x.

## [1.2.0] - 2026-04-15

### Changed
- Minor fixes and dependency optimizations for Flutter SDK compatibility.

## [1.1.0] - 2026-03-28

### Changed
- **Flutter/Dart SDK Upgrade**: Upgraded to Flutter 3.41.0 and Dart 3.11.0.
- **Improved Image Scaling**: Updated `UniversalImageViewer`, `UniversalSvgViewer`, and `UniversalLottieViewer` to explicitly pass dimensions to underlying rendering widgets.

### Fixed
- Image resizing issue where images did not respect `width` and `height` from `ImageContainerConfig` correctly in constrained layouts.

### Added
- Explicit `width` and `height` properties passed to `Image`, `CachedNetworkImage`, `SvgPicture`, and `Lottie` widgets.

## [1.0.0] - 2025-12-27

### Added
- Initial release of `gt_image_viewer`.
- `UniversalImageViewer` - Universal image widget supporting asset and network images with caching.
- `UniversalSvgViewer` - SVG image widget with color tinting support.
- `UniversalLottieViewer` - Lottie animation widget with repeat and reverse controls.
- `ImageContainerConfig` - Shared configuration for dimensions, clipping, borders, shadows, and circular avatar shape.
- `CacheManagerHelper` - Singleton cache management utility.
