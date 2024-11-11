//todo: هون حالتين موبايل + ويب
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

//! Here The Initialize of cache .
  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

//! this method to put data in local database using key

  String? getDataString({
    required String key,
  }) {
    return sharedPreferences.getString(key);
  }

//! this method to put data in local database using key

  Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    }
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    }

    if (value is int) {
      return await sharedPreferences.setInt(key, value);
    } else {
      return await sharedPreferences.setDouble(key, value);
    }
  }

//! this method to get data already saved in local database

  dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }


//! remove data using specific key

  Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

//! this method to check if local database contains {key}
  Future<bool> containsKey({required String key}) async {
    return sharedPreferences.containsKey(key);
  }

//! clear all data in the local database
  Future<bool> clearData() async {
    return await sharedPreferences.clear();
  }

//! this method to put data in local database using key
  Future<dynamic> put({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    } else {
      return await sharedPreferences.setInt(key, value);
    }
  }
}


class SecureStorageHelper {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // حفظ التوكن
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  // استرجاع التوكن
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // حذف التوكن
  Future<void> removeToken() async {
    await _storage.delete(key: 'token');
  }

  // حفظ بيانات بشكل JSON
  Future<void> saveData(String key, Map<String, dynamic> data) async {
    String jsonString = jsonEncode(data);
    await _storage.write(key: key, value: jsonString);
  }

  // استرجاع بيانات JSON
  Future<Map<String, dynamic>?> getData(String key) async {
    String? jsonData = await _storage.read(key: key);
    if (jsonData != null) {
      return jsonDecode(jsonData);
    }
    return null;
  }

  // حذف بيانات بناءً على المفتاح
  Future<void> removeData(String key) async {
    await _storage.delete(key: key);
  }
}
//طريقة الاستخدام
/*
* final secureStorageHelper = SecureStorageHelper();

// حفظ التوكن
await secureStorageHelper.saveToken('your_token_here');

// استرجاع التوكن
String? token = await secureStorageHelper.getToken();

// حذف التوكن
await secureStorageHelper.removeToken();

// حفظ بيانات JSON
await secureStorageHelper.saveData('userData', {'name': 'John Doe', 'email': 'johndoe@example.com'});

// استرجاع بيانات JSON
Map<String, dynamic>? userData = await secureStorageHelper.getData('userData');

// حذف بيانات JSON
await secureStorageHelper.removeData('userData');*/