import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Abstract local storage interface
abstract class LocalStorage {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<void> setInt(String key, int value);
  Future<int?> getInt(String key);
  Future<void> setDouble(String key, double value);
  Future<double?> getDouble(String key);
  Future<void> setObject<T>(String key, T value);
  Future<T?> getObject<T>(String key, T Function(Map<String, dynamic>) fromJson);
  Future<void> setList<T>(String key, List<T> value);
  Future<List<T>?> getList<T>(String key, T Function(Map<String, dynamic>) fromJson);
  Future<void> remove(String key);
  Future<void> clear();
  Future<bool> containsKey(String key);
}

/// SharedPreferences implementation of LocalStorage
class SharedPrefsStorage implements LocalStorage {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  @override
  Future<void> setString(String key, String value) async {
    final prefs = await _preferences;
    await prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    final prefs = await _preferences;
    return prefs.getString(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    final prefs = await _preferences;
    await prefs.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    final prefs = await _preferences;
    return prefs.getBool(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    final prefs = await _preferences;
    await prefs.setInt(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    final prefs = await _preferences;
    return prefs.getInt(key);
  }

  @override
  Future<void> setDouble(String key, double value) async {
    final prefs = await _preferences;
    await prefs.setDouble(key, value);
  }

  @override
  Future<double?> getDouble(String key) async {
    final prefs = await _preferences;
    return prefs.getDouble(key);
  }

  @override
  Future<void> setObject<T>(String key, T value) async {
    final prefs = await _preferences;
    final jsonString = jsonEncode(value);
    await prefs.setString(key, jsonString);
  }

  @override
  Future<T?> getObject<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final prefs = await _preferences;
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return fromJson(json);
  }

  @override
  Future<void> setList<T>(String key, List<T> value) async {
    final prefs = await _preferences;
    final jsonString = jsonEncode(value);
    await prefs.setString(key, jsonString);
  }

  @override
  Future<List<T>?> getList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final prefs = await _preferences;
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> remove(String key) async {
    final prefs = await _preferences;
    await prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    final prefs = await _preferences;
    await prefs.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    final prefs = await _preferences;
    return prefs.containsKey(key);
  }
}
