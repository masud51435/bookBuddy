import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/logger.dart';

abstract class FavoritesLocalDataSource {
  Future<void> addFavorite(String bookId);
  Future<void> removeFavorite(String bookId);
  Future<bool> isFavorite(String bookId);
  Future<List<String>> getFavorites();
  Future<void> clear();
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  static const String _boxName = 'favorites';
  static Box<String>? _box;
  static bool _isInitializing = false;

  Future<void> _ensureInitialized() async {
    if (_box != null) return;
    if (_isInitializing) {
      // Wait for initialization to complete
      int attempts = 0;
      while (_box == null && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }
      return;
    }

    _isInitializing = true;
    try {
      if (!Hive.isBoxOpen(_boxName)) {
        _box = await Hive.openBox<String>(_boxName);
      } else {
        _box = Hive.box<String>(_boxName);
      }
      Logger.logInfo('Favorites box initialized');
    } catch (e) {
      Logger.logError('Failed to initialize favorites box: $e', e);
      throw CacheException('Failed to initialize favorites storage: $e');
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> init() async {
    await _ensureInitialized();
  }

  @override
  Future<void> addFavorite(String bookId) async {
    try {
      await _ensureInitialized();
      await _box!.put(bookId, bookId);
      Logger.logDebug('Added book $bookId to favorites');
    } catch (e) {
      throw CacheException('Failed to add favorite: $e');
    }
  }

  @override
  Future<void> removeFavorite(String bookId) async {
    try {
      await _ensureInitialized();
      await _box!.delete(bookId);
      Logger.logDebug('Removed book $bookId from favorites');
    } catch (e) {
      throw CacheException('Failed to remove favorite: $e');
    }
  }

  @override
  Future<bool> isFavorite(String bookId) async {
    try {
      await _ensureInitialized();
      return _box!.containsKey(bookId);
    } catch (e) {
      throw CacheException('Failed to check favorite status: $e');
    }
  }

  @override
  Future<List<String>> getFavorites() async {
    try {
      await _ensureInitialized();
      return _box!.values.toList();
    } catch (e) {
      throw CacheException('Failed to get favorites: $e');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _ensureInitialized();
      await _box!.clear();
    } catch (e) {
      throw CacheException('Failed to clear favorites: $e');
    }
  }
}
