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

  AuthProvider() {
    checkLoginStatus();
  }

  // Cek status login saat aplikasi pertama kali dibuka
  Future<void> checkLoginStatus() async {
    final bool loggedIn = await _authService.isLoggedIn();
    _authState = loggedIn ? AuthState.authenticated : AuthState.unauthenticated;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final bool success = await _authService.login(username, password);

    _isLoading = false;
    if (success) {
      _authState = AuthState.authenticated;
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _authState = AuthState.unauthenticated;
    notifyListeners();
  }
}