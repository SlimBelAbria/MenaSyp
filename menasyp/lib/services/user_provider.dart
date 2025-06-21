import 'package:flutter/material.dart';
import 'package:menasyp/services/auth_service_gs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  final AuthService _authService = AuthService();

  Map<String, dynamic>? get user => _user;

  Future<void> loadCurrentUser() async {
    _user = await _authService.getCurrentUserData();
    _safeNotifyListeners();
  }

  Future<void> setUser(Map<String, dynamic> userData) async {
    await _authService.logout();
    _user = userData;
    await _saveUserData(userData);
    _safeNotifyListeners();
  }

  Future<void> clearUser() async {
    await _authService.logout();
    _user = null;
    _safeNotifyListeners();
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUserData', jsonEncode(userData));
  }

  void _safeNotifyListeners() {
    if (WidgetsBinding.instance.lifecycleState != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } else {
      notifyListeners();
    }
  }
}