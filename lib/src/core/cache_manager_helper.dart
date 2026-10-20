import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Helper class for cache management operations.
///
/// Wraps [flutter_cache_manager] functionality with a Singleton pattern
/// and preconfigured defaults for production mobile and desktop use.
class CacheManagerHelper {
  /// Internal singleton instance.
  static final CacheManagerHelper _instance = CacheManagerHelper._internal();

  /// Returns the shared [CacheManagerHelper] singleton instance.
  factory CacheManagerHelper() => _instance;

  CacheManagerHelper._internal();

  /// Custom CacheManager instance.
  CacheManager? _customCacheManager;

  /// Initialization lock to prevent concurrent initialization.
  bool _isInitializing = false;

  /// Default cache key used when none is provided.
  static const String defaultCacheKey = 'customCacheKey';

  /// Default maximum number of cached files retained on disk.
  static const int defaultMaxNrOfCacheObjects = 200;

  /// Default stale period before a cache object is considered expired.
  static const Duration defaultStalePeriod = Duration(days: 7);

  /// Store configuration for lazy initialization.
  String _configCacheKey = defaultCacheKey;
  Duration _configStalePeriod = defaultStalePeriod;
  int _configMaxCacheObjects = defaultMaxNrOfCacheObjects;

  /// Initialize the CacheManager with custom configuration.
  ///
  /// [cacheKey] sets a unique identifier for the cache repository.
  /// [stalePeriod] defines the duration before a cached object is purged.
  /// [maxNrOfCacheObjects] limits the total number of cached files.
  void initialize({
    String cacheKey = defaultCacheKey,
    Duration stalePeriod = defaultStalePeriod,
    int maxNrOfCacheObjects = defaultMaxNrOfCacheObjects,
  }) {
    _configCacheKey = cacheKey;
    _configStalePeriod = stalePeriod;
    _configMaxCacheObjects = maxNrOfCacheObjects;
    _performInitialization();
  }

  /// Internal initialization logic.
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

  /// Returns the active [CacheManager] instance.
  ///
  /// Automatically initializes with default configuration on first access if not explicitly initialized.
  CacheManager get cacheManager {
    if (_customCacheManager == null && !_isInitializing) {
      debugPrint('CacheManagerHelper auto-initializing on first use...');
      _performInitialization();
    }

    if (_customCacheManager == null) {
      return DefaultCacheManager();
    }
    return _customCacheManager!;
  }

  /// Clears all cached files from disk storage.
  Future<void> clearAllCache() async {
    await cacheManager.emptyCache();
    debugPrint('All cache cleared');
  }

  /// Alias for [clearAllCache] for documentation and API convenience.
  Future<void> clearCache() => clearAllCache();

  /// Removes a specific file from the disk cache by [url].
  Future<void> removeImageFromCache(String url) async {
    await cacheManager.removeFile(url);
    debugPrint('Removed from cache: $url');
  }

  /// Alias for [removeImageFromCache] for documentation and API convenience.
  Future<void> removeFile(String url) => removeImageFromCache(url);

  /// Retrieves cache file metadata and file pointer for the given [url].
  ///
  /// Returns null if the file is not currently cached.
  Future<FileInfo?> getFileFromCache(String url) async {
    return await cacheManager.getFileFromCache(url);
  }

  /// Checks whether an image at [url] is currently cached on disk.
  Future<bool> isImageCached(String url) async {
    final fileInfo = await cacheManager.getFileFromCache(url);
    return fileInfo != null;
  }

  /// Alias for [isImageCached].
  Future<bool> isCached(String url) => isImageCached(url);

  /// Pre-downloads and caches an image from [url] in the background without displaying it.
  Future<void> preloadImage(String url) async {
    try {
      await cacheManager.downloadFile(url);
      debugPrint('Preloaded image: $url');
    } catch (e) {
      debugPrint('Error preloading image: $e');
    }
  }

  /// Alias for [preloadImage].
  Future<void> prefetch(String url) => preloadImage(url);

  /// Gets a cached file, downloading it if it is not yet cached.
  Future<File> getSingleFile(String url, {Map<String, String>? headers}) async {
    return await cacheManager.getSingleFile(url, headers: headers);
  }

  /// Downloads a file and stores it into the cache.
  Future<FileInfo> downloadFile(
    String url, {
    Map<String, String>? headers,
  }) async {
    return await cacheManager.downloadFile(url, authHeaders: headers);
  }

  /// Logs current cache manager diagnostic information to the debug console.
  void logCacheInfo() {
    debugPrint('Cache Manager: ${cacheManager.runtimeType}');
  }

  /// Resets the internal cache manager for testing purposes.
  @visibleForTesting
  void resetForTesting() {
    _customCacheManager = null;
    _isInitializing = false;
    _configCacheKey = defaultCacheKey;
    _configStalePeriod = defaultStalePeriod;
    _configMaxCacheObjects = defaultMaxNrOfCacheObjects;
  }

  // --- Static Accessors ---

  /// Static getter for the active singleton [CacheManager].
  static CacheManager get instance => _instance.cacheManager;

  /// Static helper to clear all cache.
  static Future<void> clearAll() => _instance.clearAllCache();

  /// Static alias for [clearAll].
  static Future<void> clear() => _instance.clearAllCache();

  /// Static helper to remove a specific cached file.
  static Future<void> remove(String url) => _instance.removeImageFromCache(url);

  /// Static helper to check whether a file is cached.
  static Future<bool> checkCached(String url) => _instance.isImageCached(url);

  /// Static helper to prefetch a file.
  static Future<void> fetch(String url) => _instance.preloadImage(url);
}
