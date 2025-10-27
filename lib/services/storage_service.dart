import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static late final SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Métodos para dados offline
  Future<void> saveOfflineData(String key, Map<String, dynamic> data) async {
    await _prefs.setString(key, json.encode(data));
  }

  Future<Map<String, dynamic>?> getOfflineData(String key) async {
    final data = _prefs.getString(key);
    return data != null ? json.decode(data) : null;
  }

  Future<void> saveUserProgress(Map<String, dynamic> progress) async {
    await saveOfflineData('user_progress', progress);
  }

  Future<void> saveQuizResults(List<Map<String, dynamic>> results) async {
    await saveOfflineData('pending_sync', {
      'quiz_results': results,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}