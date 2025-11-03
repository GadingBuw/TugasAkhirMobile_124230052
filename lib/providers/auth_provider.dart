// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart';

// Status untuk mengelola alur aplikasi
enum AuthState { unknown, authenticated, unauthenticated }

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthState _authState = AuthState.unknown;
  AuthState get authState => _authState;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // --- TAMBAHKAN STATE UNTUK USERNAME AKTIF ---
  String? _activeUsername;
  String? get activeUsername => _activeUsername;
  // ------------------------------------------

  AuthProvider() {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final bool loggedIn = await _authService.isLoggedIn();
    if (loggedIn) {
      // --- AMBIL USERNAME JIKA SUDAH LOGIN ---
      _activeUsername = await _authService.getActiveUser();
      _authState = AuthState.authenticated;
    } else {
      _activeUsername = null;
      _authState = AuthState.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    final bool success = await _authService.login(username, password);
    _isLoading = false;
    if (success) {
      // --- SET USERNAME AKTIF ---
      _activeUsername = username;
      _authState = AuthState.authenticated;
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final bool success = await _authService.register(username, password);

    _isLoading = false;
    if (success) {
      // --- SET USERNAME AKTIF ---
      _activeUsername = username;
      _authState = AuthState.authenticated;
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false; // Gagal (misal: username sudah ada)
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    // --- HAPUS USERNAME AKTIF ---
    _activeUsername = null;
    _authState = AuthState.unauthenticated;
    notifyListeners();
  }
}