/// Legacy interactive example screen.
library;

import 'package:flutter/material.dart';
import 'package:gt_image_viewer/gt_image_viewer.dart';

/// Interactive sample screen demonstrating [gt_image_viewer] capabilities.
///
/// Deprecated: Refer to the standalone example application located in `example/`.
@Deprecated('Use example/lib/main.dart instead.')
class ImageHandlerExample extends StatefulWidget {
  /// Creates an image handler example widget.
  const ImageHandlerExample({super.key});

  @override
  State<ImageHandlerExample> createState() => _ImageHandlerExampleState();
}

class _ImageHandlerExampleState extends State<ImageHandlerExample> {
  final String _networkImageUrl = 'https://picsum.photos/200/300';
  final String _svgUrl =
      'https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/android.svg';

  final String _assetImage = 'assets/images/placeholder.png';
  final String _lottieUrl =
      'https://assets8.lottiefiles.com/packages/lf20_abc.json';

  @override
  void initState() {
    super.initState();
    CacheManagerHelper().initialize(
      cacheKey: 'my_custom_cache_key',
      stalePeriod: const Duration(days: 3),
      maxNrOfCacheObjects: 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Handler Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear Cache',
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              await CacheManagerHelper().clearAllCache();
              if (!mounted) return;
              messenger.showSnackBar(
                const SnackBar(content: Text('Cache Cleared!')),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Network Image (Cached)'),
            const SizedBox(height: 10),
            UniversalImageViewer.network(
              url: _networkImageUrl,
              config: const ImageContainerConfig(
                height: 200,
                width: double.infinity,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              loadingWidget: const Center(child: CircularProgressIndicator()),
              errorWidget: const Center(
                child: Icon(Icons.error, color: Colors.red),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Circular Profile Image'),
            const SizedBox(height: 10),
            Center(
              child: UniversalImageViewer.network(
                url: 'https://picsum.photos/200',
                config: const ImageContainerConfig(
                  height: 100,
                  width: 100,
                  isCircle: true,
                  backgroundColor: Colors.grey,
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.blue, width: 1),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('SVG Network'),
            const SizedBox(height: 10),
            UniversalSvgViewer.network(
              url: _svgUrl,
              config: const ImageContainerConfig(
                height: 100,
                width: 100,
                backgroundColor: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Circular SVG with Border'),
            const SizedBox(height: 10),
            Center(
              child: UniversalSvgViewer.network(
                url: _svgUrl,
                config: const ImageContainerConfig(
                  height: 120,
                  width: 120,
                  isCircle: true,
                  backgroundColor: Colors.white,
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.green, width: 4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Asset Image (Placeholder)'),
            const SizedBox(height: 10),
            UniversalImageViewer.asset(
              assetPath: _assetImage,
              config: const ImageContainerConfig(
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
              errorWidget: const Text('Asset not found'),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Lottie Network'),
            const SizedBox(height: 10),
            UniversalLottieViewer.network(
              url: _lottieUrl,
              config: const ImageContainerConfig(height: 150, width: 150),
              errorWidget: const Text('Lottie Error'),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Prefetch Image'),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Prefetch Random Image'),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final url =
                    'https://picsum.photos/200/300?random=${DateTime.now().millisecondsSinceEpoch}';
                await CacheManagerHelper().preloadImage(url);
                if (!mounted) return;
                messenger.showSnackBar(
                  SnackBar(content: Text('Prefetched: $url')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
