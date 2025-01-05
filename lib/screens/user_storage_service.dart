import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class UserStorageService {
  static final UserStorageService _instance = UserStorageService._internal();
  final _storage = const FlutterSecureStorage();

  factory UserStorageService() {
    return _instance;
  }

  UserStorageService._internal();

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final data = await _storage.read(key: 'userData');
      if (data != null) {
        return json.decode(data);
      }
      return null;
    } catch (e) {
      print('Error getting current user data: $e');
      return null;
    }
  }

  Future<void> saveUserData({
    required String email,
    required String username,
    required String phoneNumber,
    String? profilePicPath,
  }) async {
    try {
      final userData = {
        'email': email,
        'username': username,
        'phoneNumber': phoneNumber,
        'profilePicPath': profilePicPath,
        'isLoggedIn': true,
      };

      await _storage.write(
        key: 'userData',
        value: json.encode(userData),
      );

      await _storage.write(
        key: 'user_data_$phoneNumber',
        value: json.encode(userData),
      );

      await _storage.write(
        key: 'current_user',
        value: phoneNumber,
      );
    } catch (e) {
      print('Error saving user data: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>?> getUserDataByPhone(String phoneNumber) async {
    try {
      final data = await _storage.read(key: 'user_data_$phoneNumber');
      if (data != null) {
        return json.decode(data);
      }
      return null;
    } catch (e) {
      print('Error getting user data by phone: $e');
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final currentUser = await _storage.read(key: 'current_user');
      return currentUser != null;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  Future<String?> getCurrentUser() async {
    try {
      return await _storage.read(key: 'current_user');
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  Future<void> updateField(String field, String value) async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser != null) {
        final userData = await getUserDataByPhone(currentUser);
        if (userData != null) {
          userData[field] = value;
          await _storage.write(
            key: 'user_data_$currentUser',
            value: json.encode(userData),
          );
          await _storage.write(
            key: 'userData',
            value: json.encode(userData),
          );
        }
      }
    } catch (e) {
      print('Error updating field: $e');
      throw e;
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: 'current_user');
      await _storage.delete(key: 'userData');
    } catch (e) {
      print('Error during logout: $e');
      throw e;
    }
  }

  Future<void> deleteUserData(String phoneNumber) async {
    try {
      await _storage.delete(key: 'user_data_$phoneNumber');
      final currentUser = await getCurrentUser();
      if (currentUser == phoneNumber) {
        await logout();
      }
    } catch (e) {
      print('Error deleting user data: $e');
      throw e;
    }
  }
}