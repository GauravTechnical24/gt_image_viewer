import 'package:flutter/material.dart';
import 'package:gt_image_viewer/gt_image_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GT Image Viewer Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const ImageViewerExampleScreen(),
    );
  }
}

class ImageViewerExampleScreen extends StatelessWidget {
  const ImageViewerExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GT Image Viewer Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Network Image Example
            Text(
              'Network Image (Cached)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Center(
              child: UniversalImageViewer.network(
                url: 'https://picsum.photos/300/200',
                config: const ImageContainerConfig(
                  width: 300,
                  height: 200,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Circular Image Example
            Text(
              'Circular Image',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Center(
              child: UniversalImageViewer.network(
                url: 'https://picsum.photos/100/100',
                config: const ImageContainerConfig(
                  width: 100,
                  height: 100,
                  isCircle: true,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Image with Border and Shadow
            Text(
              'Styled Container',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Center(
              child: UniversalImageViewer.network(
                url: 'https://picsum.photos/250/150',
                config: ImageContainerConfig(
                  width: 250,
                  height: 150,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.purple, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Cache Management
            Text(
              'Cache Management',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () async {
                await CacheManagerHelper().clearAllCache();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cache cleared!')),
                  );
                }
              },
              icon: const Icon(Icons.delete_sweep),
              label: const Text('Clear Image Cache'),
            ),
          ],
        ),
      ),
    );
  }
}
