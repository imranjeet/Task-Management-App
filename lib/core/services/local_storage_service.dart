import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';

  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
  }

  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  static Future<void> saveUserData(String userId, String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userIdKey, userId);
      await prefs.setString(_userEmailKey, email);
      debugPrint('LocalStorageService: User data saved - userId: $userId, email: $email'); // Debug
    } catch (e) {
      debugPrint('LocalStorageService: Failed to save user data: $e'); // Debug
    }
  }

  static Future<Map<String, String?>> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_userIdKey);
      final email = prefs.getString(_userEmailKey);
      return {
        'userId': userId,
        'email': email,
      };
    } catch (e) {
      debugPrint('LocalStorageService: Failed to get user data: $e'); // Debug
      return {
        'userId': null,
        'email': null,
      };
    }
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
  }

  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
