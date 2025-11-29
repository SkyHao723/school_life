import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// StorageService handles persistent storage using SharedPreferences
class StorageService {
  SharedPreferences? _prefs;
  
  // 单例模式实现
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  /// Initialize the storage service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Ensure prefs is initialized
  Future<SharedPreferences> get prefs async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  /// Save a string value
  Future<bool> setString(String key, String value) async {
    final p = await prefs;
    return await p.setString(key, value);
  }

  /// Get a string value
  Future<String?> getString(String key) async {
    final p = await prefs;
    return p.getString(key);
  }

  /// Save an integer value
  Future<bool> setInt(String key, int value) async {
    final p = await prefs;
    return await p.setInt(key, value);
  }

  /// Get an integer value
  Future<int?> getInt(String key) async {
    final p = await prefs;
    return p.getInt(key);
  }

  /// Save a boolean value
  Future<bool> setBool(String key, bool value) async {
    final p = await prefs;
    return await p.setBool(key, value);
  }

  /// Get a boolean value
  Future<bool?> getBool(String key) async {
    final p = await prefs;
    return p.getBool(key);
  }

  /// Save a double value
  Future<bool> setDouble(String key, double value) async {
    final p = await prefs;
    return await p.setDouble(key, value);
  }

  /// Get a double value
  Future<double?> getDouble(String key) async {
    final p = await prefs;
    return p.getDouble(key);
  }

  /// Save an object (serialized as JSON)
  Future<bool> saveObject(String key, Object object) async {
    final jsonString = jsonEncode(object);
    return await setString(key, jsonString);
  }

  /// Load an object (deserialized from JSON)
  Future<T?> loadObject<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    final jsonString = await getString(key);
    if (jsonString == null) return null;
    
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Remove a value
  Future<bool> remove(String key) async {
    final p = await prefs;
    return await p.remove(key);
  }

  /// Clear all values
  Future<bool> clear() async {
    final p = await prefs;
    return await p.clear();
  }
}