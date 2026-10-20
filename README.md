# GT Image Viewer

[![pub package](https://img.shields.io/pub/v/gt_image_viewer.svg)](https://pub.dev/packages/gt_image_viewer)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A universal Flutter image viewer package supporting network images with caching, SVG rendering, and Lottie animations with configurable containers and dedicated Material, Cupertino, and platform-adaptive UI styles.

## Features

- 🖼️ **Cached Network Images** - Automatic caching via `cached_network_image` and `flutter_cache_manager`.
- 📐 **SVG Vector Support** - Asset and network SVG rendering via `flutter_svg`.
- 🎬 **Lottie Animations** - Asset and network Lottie files via `lottie`.
- 🍏 **Cupertino & Material Support** - Dedicated iOS/macOS Cupertino widgets, Material Design widgets, or automatic platform-adaptive switching.
- ⚙️ **Configurable Containers** - Width, height, border, shadow, padding, margin, and clipping.
- ⭕ **Circular Images** - First-class circular avatar and icon container support.
- 🎨 **Custom Error & Loading Widgets** - Fully customizable loaders and failure states.
- 💾 **Cache Management** - Singleton cache manager helper with prefetching and cache clearing.

## Installation

Add `gt_image_viewer` to your `pubspec.yaml`:

```yaml
dependencies:
  gt_image_viewer: ^1.3.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Adaptive Universal Network Image (Cached)

```dart
import 'package:flutter/material.dart';
import 'package:gt_image_viewer/gt_image_viewer.dart';

UniversalImageViewer.network(
  url: 'https://example.com/image.png',
  config: const ImageContainerConfig(
    width: 200,
    height: 200,
    fit: BoxFit.cover,
    borderRadius: BorderRadius.all(Radius.circular(12)),
  ),
);
```

### 2. Cupertino (iOS/macOS Style) Image Viewer

Uses `CupertinoActivityIndicator` and native iOS error widgets:

```dart
CupertinoImageViewer.network(
  url: 'https://example.com/photo.png',
  config: const ImageContainerConfig(
    width: 150,
    height: 150,
  ),
);
```

### 3. Material Design Image Viewer

Uses `CircularProgressIndicator` and Material error widgets:

```dart
MaterialImageViewer.network(
  url: 'https://example.com/photo.png',
  config: const ImageContainerConfig(
    width: 150,
    height: 150,
  ),
);
```

### 4. Circular Profile Avatar

```dart
UniversalImageViewer.network(
  url: 'https://example.com/avatar.png',
  config: const ImageContainerConfig(
    width: 80,
    height: 80,
    isCircle: true,
    backgroundColor: Colors.grey,
    border: Border.fromBorderSide(
      BorderSide(color: Colors.blue, width: 2),
    ),
  ),
);
```

### 5. Local Asset Image

```dart
UniversalImageViewer.asset(
  assetPath: 'assets/images/logo.png',
  config: const ImageContainerConfig(
    width: 100,
    height: 100,
  ),
);
```

### 6. SVG Vector Graphics

```dart
// Asset SVG
UniversalSvgViewer.asset(
  svgPath: 'assets/icons/logo.svg',
  config: const ImageContainerConfig(width: 48, height: 48),
  color: Colors.blue, // Optional tint filter
);

// Network SVG
UniversalSvgViewer.network(
  url: 'https://example.com/icon.svg',
);
```

### 7. Lottie Animations

```dart
// Asset Lottie
UniversalLottieViewer.asset(
  lottiePath: 'assets/animations/loading.json',
  config: const ImageContainerConfig(width: 120, height: 120),
);

// Network Lottie
UniversalLottieViewer.network(
  url: 'https://example.com/animation.json',
);
```

## ImageContainerConfig Options

| Property | Type | Description | Default |
|---|---|---|---|
| `width` | `double?` | Container width constraint | `null` |
| `height` | `double?` | Container height constraint | `null` |
| `fit` | `BoxFit` | How image is inscribed into container | `BoxFit.cover` |
| `alignment` | `Alignment` | Image alignment within bounds | `Alignment.center` |
| `isCircle` | `bool` | Whether to render as circle | `false` |
| `borderRadius` | `BorderRadius?` | Rounded corners | `null` |
| `backgroundColor`| `Color?` | Background fill color | `null` |
| `border` | `Border?` | Border stroke | `null` |
| `boxShadow` | `List<BoxShadow>?` | Drop shadows | `null` |
| `padding` | `EdgeInsetsGeometry?` | Inner padding | `null` |
| `margin` | `EdgeInsetsGeometry?` | Outer margin | `null` |
| `clipBehavior` | `Clip` | Container clip behavior | `Clip.antiAlias` |
| `designSystem` | `ImageDesignSystem` | `adaptive`, `material`, or `cupertino` | `adaptive` |

## Cache Management

Control disk and memory image caching with `CacheManagerHelper`:

```dart
// Access singleton instance
final helper = CacheManagerHelper();

// Clear all cached images
await helper.clearAllCache();

// Remove a specific image URL from cache
await helper.removeImageFromCache('https://example.com/image.png');

// Check if an image is cached
final isCached = await helper.isImageCached('https://example.com/image.png');

// Prefetch and download in background
await helper.preloadImage('https://example.com/image.png');
```

## License

MIT License - see [LICENSE](LICENSE) for details.
