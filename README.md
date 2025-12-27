# GT Image Viewer

[![pub package](https://img.shields.io/pub/v/gt_image_viewer.svg)](https://pub.dev/packages/gt_image_viewer)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A universal Flutter image viewer package supporting network images with caching, SVG rendering, and Lottie animations with configurable containers.

## Features

- 🖼️ **Cached Network Images** - Automatic caching via cached_network_image
- 📐 **SVG Support** - Asset and network SVG rendering
- 🎬 **Lottie Animations** - Asset and network Lottie files
- ⚙️ **Configurable Containers** - Width, height, border, shadow, padding
- ⭕ **Circular Images** - Easy circular image support
- 🎨 **Custom Widgets** - Error and loading widget customization
- 💾 **Cache Management** - Built-in cache manager helper

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  gt_image_viewer: ^1.0.0
```

Then run:
```bash
flutter pub get
```

## Quick Start

### Network Image (Cached)

```dart
import 'package:gt_image_viewer/gt_image_viewer.dart';

UniversalImageViewer.network(
  url: 'https://example.com/image.png',
  config: ImageContainerConfig(
    width: 200,
    height: 200,
    fit: BoxFit.cover,
  ),
)
```

### Asset Image

```dart
UniversalImageViewer.asset(
  assetPath: 'assets/images/logo.png',
  config: ImageContainerConfig(
    width: 100,
    height: 100,
  ),
)
```

### Circular Image

```dart
UniversalImageViewer.network(
  url: 'https://example.com/avatar.png',
  config: ImageContainerConfig(
    width: 80,
    height: 80,
    isCircle: true,
  ),
)
```

### SVG Image

```dart
// Asset SVG
UniversalSvgViewer.asset(
  svgPath: 'assets/icons/logo.svg',
  config: ImageContainerConfig(width: 48, height: 48),
  color: Colors.blue, // Optional tint
)

// Network SVG
UniversalSvgViewer.network(
  url: 'https://example.com/icon.svg',
)
```

### Lottie Animation

```dart
// Asset Lottie
UniversalLottieViewer.asset(
  assetPath: 'assets/animations/loading.json',
  config: ImageContainerConfig(width: 100, height: 100),
)

// Network Lottie
UniversalLottieViewer.network(
  url: 'https://example.com/animation.json',
)
```

## ImageContainerConfig Options

```dart
ImageContainerConfig(
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  alignment: Alignment.center,
  isCircle: false,
  borderRadius: BorderRadius.circular(12),
  backgroundColor: Colors.grey[200],
  padding: EdgeInsets.all(8),
  margin: EdgeInsets.all(4),
  border: Border.all(color: Colors.black),
  boxShadow: [BoxShadow(blurRadius: 4)],
  clipBehavior: Clip.antiAlias,
)
```

## Cache Management

```dart
// Get cache manager
final cacheManager = CacheManagerHelper().cacheManager;

// Clear all cache
await CacheManagerHelper().clearCache();

// Remove specific file from cache
await CacheManagerHelper().removeFile('https://example.com/image.png');
```

## License

MIT License - see [LICENSE](LICENSE) for details.
