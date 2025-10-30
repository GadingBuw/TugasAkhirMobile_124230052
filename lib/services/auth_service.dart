// lib/services/auth_service.dart

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // --- DATABASE PENGGUNA DUMMY ---
  // Di aplikasi nyata, ini ada di server Anda.
  // Kita simpan HASH dari password, bukan password aslinya.
  // 'password123' di-hash dengan SHA-256 menjadi:
  // 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f'
  final Map<String, String> _dummyUserDatabase = {
    'user': 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f',
    'admin': 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f',
  };
  // --------------------------------

  static const String _sessionKey = 'isLoggedIn';

  // Fungsi untuk hashing password
  String _hashPassword(String password) {
    final bytes = utf8.encode(password); // Ubah password ke bytes
    final digest = sha256.convert(bytes); // Hash menggunakan SHA-256
    return digest.toString(); // Kembalikan sebagai string
  }

  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Hash password yang diinput pengguna
    final inputPasswordHash = _hashPassword(password);

    // 2. Cek apakah username ada di database
    if (_dummyUserDatabase.containsKey(username)) {
      // 3. Bandingkan hash password
      if (_dummyUserDatabase[username] == inputPasswordHash) {
        // 4. Jika cocok, simpan session
        await prefs.setBool(_sessionKey, true);
        return true;
      }
    }
    // Jika username salah atau password salah
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sessionKey, false);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sessionKey) ?? false;
  }
}