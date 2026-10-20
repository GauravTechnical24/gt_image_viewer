import 'package:flutter/material.dart';
import 'package:gt_image_viewer/gt_image_viewer.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget with dynamic ThemeMode support (Light, Dark, System).
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  /// Allows descendant widgets to change the app theme mode.
  static void setThemeMode(BuildContext context, ThemeMode mode) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeTheme(mode);
  }

  /// Returns current theme mode.
  static ThemeMode getThemeMode(BuildContext context) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    return state?.themeMode ?? ThemeMode.system;
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;

  void changeTheme(ThemeMode mode) {
    setState(() {
      themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryIndigo = Color(0xFF6366F1);

    final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryIndigo,
        brightness: Brightness.light,
        surface: const Color(0xFFF8FAFC),
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.black.withAlpha(15)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF0F172A),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primaryIndigo,
        unselectedLabelColor: const Color(0xFF64748B),
        indicatorColor: primaryIndigo,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.black.withAlpha(10),
      ),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF818CF8),
        brightness: Brightness.dark,
        surface: const Color(0xFF0F172A),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withAlpha(20)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: Color(0xFF1E293B),
        foregroundColor: Color(0xFFF8FAFC),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: Color(0xFF818CF8),
        unselectedLabelColor: Color(0xFF94A3B8),
        indicatorColor: Color(0xFF818CF8),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
      ),
    );

    return MaterialApp(
      title: 'GT Image Viewer Example',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const ImageViewerExampleScreen(),
    );
  }
}

/// Main application screen featuring a modern tabbed layout and controls.
class ImageViewerExampleScreen extends StatefulWidget {
  const ImageViewerExampleScreen({super.key});

  @override
  State<ImageViewerExampleScreen> createState() =>
      _ImageViewerExampleScreenState();
}

class _ImageViewerExampleScreenState extends State<ImageViewerExampleScreen> {
  // Playground state
  double _playgroundWidth = 180.0;
  double _playgroundHeight = 180.0;
  double _playgroundRadius = 16.0;
  bool _playgroundIsCircle = false;
  BoxFit _playgroundFit = BoxFit.cover;
  ImageDesignSystem _playgroundDesignSystem = ImageDesignSystem.adaptive;

  // Comparison toggle state
  bool _simulateError = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentMode = MyApp.getThemeMode(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.image_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GT Image Viewer Example',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'v1.3.0 • 160/160 pub.dev score',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            // Theme Mode Menu
            PopupMenuButton<ThemeMode>(
              tooltip: 'Switch Theme',
              icon: Icon(
                currentMode == ThemeMode.system
                    ? Icons.brightness_auto_rounded
                    : currentMode == ThemeMode.dark
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              onSelected: (mode) => MyApp.setThemeMode(context, mode),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: ThemeMode.system,
                  child: Row(
                    children: [
                      Icon(Icons.brightness_auto_rounded, size: 20),
                      SizedBox(width: 12),
                      Text('System Default'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: ThemeMode.light,
                  child: Row(
                    children: [
                      Icon(Icons.light_mode_rounded, size: 20),
                      SizedBox(width: 12),
                      Text('Light Theme'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: ThemeMode.dark,
                  child: Row(
                    children: [
                      Icon(Icons.dark_mode_rounded, size: 20),
                      SizedBox(width: 12),
                      Text('Dark Theme'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(icon: Icon(Icons.auto_awesome_rounded), text: 'Showcase'),
              Tab(
                icon: Icon(Icons.compare_arrows_rounded),
                text: 'Material vs Cupertino',
              ),
              Tab(icon: Icon(Icons.tune_rounded), text: 'Live Playground'),
              Tab(icon: Icon(Icons.storage_rounded), text: 'Cache Console'),
            ],
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: TabBarView(
              children: [
                _buildShowcaseTab(context, isDark),
                _buildComparisonTab(context, isDark),
                _buildPlaygroundTab(context, isDark),
                _buildCacheConsoleTab(context, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // TAB 1: SHOWCASE
  // ==========================================
  Widget _buildShowcaseTab(BuildContext context, bool isDark) {
    final surfaceColor = Theme.of(context).cardTheme.color;
    final borderColor = isDark
        ? Colors.white.withAlpha(20)
        : Colors.black.withAlpha(15);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        // Hero Network Image Card
        _buildSectionHeader(
          title: 'Network Image (Cached)',
          subtitle: 'Cached automatically with disk persistence, memory throttling, and smooth fade-in animations.',
          badge: 'cached_network_image 4.x',
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: UniversalImageViewer.network(
                    url: 'https://picsum.photos/600/350',
                    config: ImageContainerConfig(
                      width: double.infinity,
                      height: 220,
                      borderRadius: BorderRadius.circular(16),
                      backgroundColor: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _buildFeatureTag(Icons.speed_rounded, 'Auto Disk Cache'),
                    _buildFeatureTag(Icons.animation_rounded, '500ms Fade-in'),
                    _buildFeatureTag(Icons.memory_rounded, 'Memory Optimized'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Material & Cupertino Comparison Banner
        _buildSectionHeader(
          title: 'Material & Cupertino Styling',
          subtitle: 'Decoupled UI components adapting natively to iOS Cupertino or Material 3 design systems.',
          badge: 'Adaptive UI',
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withAlpha(30),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Material 3',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      MaterialImageViewer.network(
                        url: 'https://picsum.photos/160/160?random=11',
                        config: ImageContainerConfig(
                          width: 120,
                          height: 120,
                          borderRadius: BorderRadius.circular(16),
                          backgroundColor: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'CircularProgressIndicator',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 150, color: borderColor),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withAlpha(30),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Cupertino iOS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      CupertinoImageViewer.network(
                        url: 'https://picsum.photos/160/160?random=12',
                        config: ImageContainerConfig(
                          width: 120,
                          height: 120,
                          borderRadius: BorderRadius.circular(16),
                          backgroundColor: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'CupertinoActivityIndicator',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Circular Image Section
        _buildSectionHeader(
          title: 'Circular Image',
          subtitle: 'First-class avatar and circular styling with single-boolean configuration.',
          badge: 'isCircle: true',
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                // Small avatar
                Column(
                  children: [
                    UniversalImageViewer.network(
                      url: 'https://picsum.photos/100/100?random=21',
                      config: const ImageContainerConfig(
                        width: 54,
                        height: 54,
                        isCircle: true,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text('54x54 Mini', style: TextStyle(fontSize: 11)),
                  ],
                ),
                // Medium avatar with border
                Column(
                  children: [
                    UniversalImageViewer.network(
                      url: 'https://picsum.photos/150/150?random=22',
                      config: ImageContainerConfig(
                        width: 84,
                        height: 84,
                        isCircle: true,
                        border: Border.all(
                          color: const Color(0xFF6366F1),
                          width: 2.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text('84x84 Border', style: TextStyle(fontSize: 11)),
                  ],
                ),
                // Large profile avatar with shadow
                Column(
                  children: [
                    UniversalImageViewer.network(
                      url: 'https://picsum.photos/200/200?random=23',
                      config: ImageContainerConfig(
                        width: 110,
                        height: 110,
                        isCircle: true,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withAlpha(80),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '110x110 Glowing',
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Styled Container Section
        _buildSectionHeader(
          title: 'Styled Container',
          subtitle: 'Customize padding, margin, shadows, clipping, and custom aspect ratios.',
          badge: 'BoxDecoration',
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: UniversalImageViewer.network(
                url: 'https://picsum.photos/320/200?random=31',
                config: ImageContainerConfig(
                  width: 280,
                  height: 170,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFA855F7),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFA855F7).withAlpha(50),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),

        // SVG Vector Graphic Section
        _buildSectionHeader(
          title: 'SVG Vector Graphics',
          subtitle: 'Crisp vector rendering from asset bundle or network URLs with live color filters.',
          badge: 'flutter_svg 2.x',
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    UniversalSvgViewer.asset(
                      svgPath: 'assets/sample.svg',
                      config: ImageContainerConfig(
                        width: 80,
                        height: 80,
                        backgroundColor: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Asset SVG', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    UniversalSvgViewer.asset(
                      svgPath: 'assets/sample.svg',
                      color: const Color(0xFF6366F1),
                      config: ImageContainerConfig(
                        width: 80,
                        height: 80,
                        backgroundColor: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Tinted Indigo', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    UniversalSvgViewer.asset(
                      svgPath: 'assets/sample.svg',
                      color: const Color(0xFF10B981),
                      config: ImageContainerConfig(
                        width: 80,
                        height: 80,
                        isCircle: true,
                        border: Border.all(
                          color: const Color(0xFF10B981),
                          width: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Circular SVG', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Cache Action Card
        Card(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: const Color(0xFF6366F1).withAlpha(50),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 450;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withAlpha(20),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.delete_sweep_rounded,
                            color: Color(0xFFEF4444),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Disk Cache Management',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Instantly purge disk and memory cache with the singleton helper.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: isNarrow ? double.infinity : null,
                      child: FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444)
                              .withAlpha(25),
                          foregroundColor: const Color(0xFFEF4444),
                        ),
                        onPressed: () async {
                          await CacheManagerHelper().clearAllCache();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  'Image cache purged successfully!',
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.cleaning_services_rounded,
                          size: 18,
                        ),
                        label: const Text('Clear Image Cache'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ==========================================
  // TAB 2: MATERIAL VS CUPERTINO COMPARISON
  // ==========================================
  Widget _buildComparisonTab(BuildContext context, bool isDark) {
    final testUrl = _simulateError
        ? 'https://invalid-non-existing-domain-test.com/404.png'
        : 'https://picsum.photos/400/400?random=99';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionHeader(
          title: 'Design System Comparison',
          subtitle: 'Inspect how Material 3 and Cupertino native UI adapt to loading spinners, error widgets, and borders.',
          badge: 'Native Parity',
        ),
        const SizedBox(height: 16),
        // Simulation Toggle Bar
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.tune_rounded, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Simulate Loading / Error State',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: _simulateError,
                  onChanged: (val) {
                    setState(() {
                      _simulateError = val;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;

            final materialCard = Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      children: [
                        const Icon(
                          Icons.android_rounded,
                          color: Color(0xFF6366F1),
                          size: 20,
                        ),
                        Text(
                          'Material 3 Mode',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    MaterialImageViewer.network(
                      key: ValueKey('mat_$_simulateError'),
                      url: testUrl,
                      config: ImageContainerConfig(
                        width: double.infinity,
                        height: 180,
                        borderRadius: BorderRadius.circular(16),
                        backgroundColor: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSpecRow('Spinner', 'CircularProgressIndicator'),
                    _buildSpecRow('Error Icon', 'Icons.error_outline'),
                    _buildSpecRow('Error Color', 'Theme.colorScheme.error'),
                  ],
                ),
              ),
            );

            final cupertinoCard = Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      children: [
                        Icon(
                          Icons.apple_rounded,
                          color: Color(0xFF10B981),
                          size: 20,
                        ),
                        Text(
                          'Cupertino iOS Mode',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CupertinoImageViewer.network(
                      key: ValueKey('cup_$_simulateError'),
                      url: testUrl,
                      config: ImageContainerConfig(
                        width: double.infinity,
                        height: 180,
                        borderRadius: BorderRadius.circular(16),
                        backgroundColor: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSpecRow('Spinner', 'CupertinoActivityIndicator'),
                    _buildSpecRow(
                      'Error Icon',
                      'CupertinoIcons.exclamationmark',
                    ),
                    _buildSpecRow('Error Color', 'CupertinoColors.systemRed'),
                  ],
                ),
              ),
            );

            if (isMobile) {
              return Column(
                children: [
                  materialCard,
                  const SizedBox(height: 16),
                  cupertinoCard,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: materialCard),
                const SizedBox(width: 16),
                Expanded(child: cupertinoCard),
              ],
            );
          },
        ),
      ],
    );
  }

  // ==========================================
  // TAB 3: LIVE PLAYGROUND
  // ==========================================
  Widget _buildPlaygroundTab(BuildContext context, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionHeader(
          title: 'Interactive Playground',
          subtitle: 'Adjust parameters in real-time to preview container behavior and copy production Dart code.',
          badge: 'Live Preview',
        ),
        const SizedBox(height: 20),
        // Live Preview Box
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: UniversalImageViewer.network(
                url: 'https://picsum.photos/400/400?random=88',
                config: ImageContainerConfig(
                  width: _playgroundWidth,
                  height: _playgroundHeight,
                  borderRadius: BorderRadius.circular(_playgroundRadius),
                  isCircle: _playgroundIsCircle,
                  fit: _playgroundFit,
                  designSystem: _playgroundDesignSystem,
                  border: Border.all(color: const Color(0xFF6366F1), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withAlpha(50),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Controls Form
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Width Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Width Constraint'),
                    Text(
                      '${_playgroundWidth.toInt()} px',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Slider(
                  value: _playgroundWidth,
                  min: 60,
                  max: 300,
                  onChanged: (val) => setState(() => _playgroundWidth = val),
                ),

                // Height Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Height Constraint'),
                    Text(
                      '${_playgroundHeight.toInt()} px',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Slider(
                  value: _playgroundHeight,
                  min: 60,
                  max: 260,
                  onChanged: (val) => setState(() => _playgroundHeight = val),
                ),

                // Border Radius Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Border Radius'),
                    Text(
                      '${_playgroundRadius.toInt()} px',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Slider(
                  value: _playgroundRadius,
                  min: 0,
                  max: 50,
                  onChanged: (val) => setState(() => _playgroundRadius = val),
                ),

                const Divider(height: 28),

                // Circular Toggle
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Force Circular Shape (isCircle)'),
                  subtitle: const Text(
                    'Auto-calculates radius to create a perfect circle avatar',
                  ),
                  value: _playgroundIsCircle,
                  onChanged: (val) => setState(() => _playgroundIsCircle = val),
                ),

                const Divider(height: 28),

                // BoxFit Dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('BoxFit Mode:'),
                    DropdownButton<BoxFit>(
                      value: _playgroundFit,
                      items: BoxFit.values.map((fit) {
                        return DropdownMenuItem(
                          value: fit,
                          child: Text(fit.name),
                        );
                      }).toList(),
                      onChanged: (fit) {
                        if (fit != null) {
                          setState(() => _playgroundFit = fit);
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Design System Selector
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Design System:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<ImageDesignSystem>(
                        segments: const [
                          ButtonSegment(
                            value: ImageDesignSystem.adaptive,
                            label: Text('Adaptive'),
                          ),
                          ButtonSegment(
                            value: ImageDesignSystem.material,
                            label: Text('Material'),
                          ),
                          ButtonSegment(
                            value: ImageDesignSystem.cupertino,
                            label: Text('Cupertino'),
                          ),
                        ],
                        selected: {_playgroundDesignSystem},
                        onSelectionChanged: (set) {
                          setState(() => _playgroundDesignSystem = set.first);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 4: CACHE CONSOLE
  // ==========================================
  Widget _buildCacheConsoleTab(BuildContext context, bool isDark) {
    final textController = TextEditingController(
      text: 'https://picsum.photos/400/400?random=101',
    );

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionHeader(
          title: 'Cache Console & Prefetching',
          subtitle: 'Inspect, pre-download, and purge cached images programmatically.',
          badge: 'flutter_cache_manager 3.4.5',
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Prefetch Image in Background',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Download and cache an image before showing it on screen to prevent pop-in delay.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    labelText: 'Target Image URL',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.link_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    FilledButton.icon(
                      onPressed: () async {
                        final url = textController.text.trim();
                        await CacheManagerHelper().preloadImage(url);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                'Prefetched image into cache: $url',
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Prefetch Image'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final url = textController.text.trim();
                        final isCached = await CacheManagerHelper()
                            .isImageCached(url);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                isCached
                                    ? 'Image IS present in disk cache! ✓'
                                    : 'Image is NOT in disk cache.',
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.check_circle_outline_rounded),
                      label: const Text('Check Cached'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Cache Stats Info Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildSpecRow('Default Cache Stale Period', '7 Days'),
                _buildSpecRow('Max Disk Cached Objects', '200 Items'),
                _buildSpecRow('Repository Type', 'JsonCacheInfoRepository'),
                _buildSpecRow('Cache Management Pattern', 'Singleton Helper'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================
  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required String badge,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6366F1),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildFeatureTag(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF6366F1)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
