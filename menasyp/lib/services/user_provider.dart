import 'package:flutter/material.dart';
import 'package:menasyp/services/auth_service_gs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Provider for managing user state throughout the application
class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  /// Current user data
  Map<String, dynamic>? get user => _user;
  
  /// Check if user is logged in
  bool get isLoggedIn => _user != null;
  
  /// Check if current user is admin
  bool get isAdmin => _user?['isAdmin'] == true;
  
  /// Loading state
  bool get isLoading => _isLoading;

  /// Load current user data from storage
  Future<void> loadCurrentUser() async {
    _setLoading(true);
    try {
      final userData = await _authService.getCurrentUserData();
      if (userData != null) {
        _user = userData;
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Set user data and save to storage
  Future<void> setUser(Map<String, dynamic> userData) async {
    _setLoading(true);
    try {
      await _authService.logout();
      _user = userData;
      await _saveUserData(userData);
      _safeNotifyListeners();
    } catch (e) {
      debugPrint('Error setting user: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Clear user data and logout
  Future<void> clearUser() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _user = null;
      await _clearUserData();
      _safeNotifyListeners();
    } catch (e) {
      debugPrint('Error clearing user: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Update user data
  Future<void> updateUser(Map<String, dynamic> updatedUser) async {
    _setLoading(true);
    try {
      _user = updatedUser;
      await _saveUserData(updatedUser);
      _safeNotifyListeners();
    } catch (e) {
      debugPrint('Error updating user: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Save user data to local storage
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentUserData', jsonEncode(userData));
    } catch (e) {
      debugPrint('Error saving user data: $e');
    }
  }

  /// Clear user data from local storage
  Future<void> _clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('currentUserData');
    } catch (e) {
      debugPrint('Error clearing user data: $e');
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    _safeNotifyListeners();
  }

  /// Safely notify listeners
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