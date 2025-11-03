import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart'; 
import '../models/user_model.dart'; 

class AuthService {
  final Box<User> _userBox = Hive.box<User>('users');

  static const String _sessionKey = 'isLoggedIn';
  static const String _userKey = 'activeUsername';

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> register(String username, String password) async {
    if (_userBox.containsKey(username)) {
      return false; 
    }

    final newPasswordHash = _hashPassword(password);
    final newUser = User(
      username: username,
      passwordHash: newPasswordHash,
    );
    await _userBox.put(username, newUser);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sessionKey, true);
    await prefs.setString(_userKey, username);
    return true;
  }

  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final inputPasswordHash = _hashPassword(password);
    final User? user = _userBox.get(username);

    if (user != null) {
      if (user.passwordHash == inputPasswordHash) {
        await prefs.setBool(_sessionKey, true);
        await prefs.setString(_userKey, username);
        return true;
      }
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sessionKey, false);
    await prefs.remove(_userKey);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sessionKey) ?? false;
  }

  Future<String?> getActiveUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }
}