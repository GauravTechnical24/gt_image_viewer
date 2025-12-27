import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Helper class for cache management operations
/// Wraps flutter_cache_manager functionality with Singleton pattern
/// and optimized configuration for production use.
class CacheManagerHelper {
  // Singleton instance
  static final CacheManagerHelper _instance = CacheManagerHelper._internal();

  factory CacheManagerHelper() {
    return _instance;
  }

  CacheManagerHelper._internal();

  /// Custom CacheManager instance
  CacheManager? _customCacheManager;

  /// Initialization lock to prevent concurrent initialization
  bool _isInitializing = false;

  /// Default configuration values
  static const String _key = 'customCacheKey';
  static const int _maxNrOfCacheObjects = 200;
  static const Duration _stalePeriod = Duration(days: 7);

  /// Store configuration for lazy initialization
  String _configCacheKey = _key;
  Duration _configStalePeriod = _stalePeriod;
  int _configMaxCacheObjects = _maxNrOfCacheObjects;

  /// Initialize the CacheManager with custom configuration
  /// [cacheKey] - Unique key for the cache
  /// [stalePeriod] - Duration before a cache object is considered stale
  /// [maxNrOfCacheObjects] - Maximum number of objects to keep in cache
  void initialize({
    String cacheKey = _key,
    Duration stalePeriod = _stalePeriod,
    int maxNrOfCacheObjects = _maxNrOfCacheObjects,
  }) {
    // Store config for lazy initialization
    _configCacheKey = cacheKey;
    _configStalePeriod = stalePeriod;
    _configMaxCacheObjects = maxNrOfCacheObjects;

    // Only actually initialize if explicitly called
    _performInitialization();
  }

  /// Internal initialization logic
  void _performInitialization() {
    if (_customCacheManager != null || _isInitializing) return;

    _isInitializing = true;
    _customCacheManager = CacheManager(
      Config(
        _configCacheKey,
        stalePeriod: _configStalePeriod,
        maxNrOfCacheObjects: _configMaxCacheObjects,
        repo: JsonCacheInfoRepository(databaseName: _configCacheKey),
        fileService: HttpFileService(),
      ),
    );
    _isInitializing = false;
    debugPrint('CacheManagerHelper initialized with key: $_configCacheKey');
  }

  /// Get the active CacheManager instance
  /// Auto-initializes with default config on first use if not explicitly initialized
  CacheManager get cacheManager {
    if (_customCacheManager == null && !_isInitializing) {
      debugPrint('CacheManagerHelper auto-initializing on first use...');
      _performInitialization();
    }

    if (_customCacheManager == null) {
      // Fallback to default if initialization is in progress
      return DefaultCacheManager();
    }
    return _customCacheManager!;
  }

  /// Clear all cached images
  Future<void> clearAllCache() async {
    await cacheManager.emptyCache();
    debugPrint('All cache cleared');
  }

  /// Remove specific image from cache
  Future<void> removeImageFromCache(String url) async {
    await cacheManager.removeFile(url);
    debugPrint('Removed from cache: $url');
  }

  /// Get file from cache
  Future<FileInfo?> getFileFromCache(String url) async {
    return await cacheManager.getFileFromCache(url);
  }

  /// Check if image exists in cache
  Future<bool> isImageCached(String url) async {
    final fileInfo = await cacheManager.getFileFromCache(url);
    return fileInfo != null;
  }

  /// Download and cache image without displaying (Prefetch)
  Future<void> preloadImage(String url) async {
    try {
      await cacheManager.downloadFile(url);
      debugPrint('Preloaded image: $url');
    } catch (e) {
      debugPrint('Error preloading image: $e');
    }
  }

  /// Get file from cache or download if not available
  Future<File> getSingleFile(String url, {Map<String, String>? headers}) async {
    return await cacheManager.getSingleFile(url, headers: headers);
  }

  /// Download file and put in cache
  Future<FileInfo> downloadFile(
    String url, {
    Map<String, String>? headers,
  }) async {
    return await cacheManager.downloadFile(url, authHeaders: headers);
  }

  /// Get cache information (Debug only)
  void logCacheInfo() {
    debugPrint('Cache Manager: ${cacheManager.runtimeType}');
    // Note: Detailed stats might require accessing the repository directly which is internal
  }

  // --- Static forwards for backward compatibility and ease of use ---

  /// Static access to the singleton's cacheManager
  static CacheManager get instance => _instance.cacheManager;

  static Future<void> clearAll() => _instance.clearAllCache();

  static Future<void> removeFile(String url) =>
      _instance.removeImageFromCache(url);

  static Future<bool> isCached(String url) => _instance.isImageCached(url);

  static Future<void> prefetch(String url) => _instance.preloadImage(url);
}
