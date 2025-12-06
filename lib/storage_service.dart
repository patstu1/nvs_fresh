// packages/core/lib/storage_service.dart
// Storage Service for NVS Quantum Architecture

import 'dart:convert';

class StorageService {
  static final StorageService _instance = StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  final Map<String, String> _storage = {};

  Future<void> setString(String key, String value) async {
    _storage[key] = value;
  }

  Future<String?> getString(String key) async {
    return _storage[key];
  }

  Future<void> setObject(String key, Map<String, dynamic> object) async {
    _storage[key] = jsonEncode(object);
  }

  Future<Map<String, dynamic>?> getObject(String key) async {
    final value = _storage[key];
    if (value != null) {
      return jsonDecode(value);
    }
    return null;
  }

  Future<void> remove(String key) async {
    _storage.remove(key);
  }

  Future<void> clear() async {
    _storage.clear();
  }
}
