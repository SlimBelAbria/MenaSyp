import 'package:flutter/material.dart';
import 'package:menasyp/services/google_sheet_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  final GoogleSheetsService _googleSheetsService = GoogleSheetsService();
  final String _csvUrl =
      'https://docs.google.com/spreadsheets/d/e/2PACX-1vSEAEDhje20E1rev37xZE8xytcj7o4TqC-dqd99o4vQSk_VYLF92oQry6mtatdtPhKoJcd5dXhqutJi/pub?gid=0&single=true&output=csv';

  static const String _prefKey = 'loggedInUser';
  static const String _userDataKey = 'currentUserData';

  Future<SharedPreferences> getPrefsInstance() async {
    return await SharedPreferences.getInstance();
  }

  String encodeUserData(Map<String, dynamic> userData) {
    return jsonEncode(userData);
  }

  Future<List<Map<String, String>>> fetchUsers() async {
    try {
   
      final sheetData = await _googleSheetsService.fetchSheetData(_csvUrl);
      final List<Map<String, String>> users = [];

      for (var i = 1; i < sheetData.length; i++) {
        final row = sheetData[i];
        if (row.length >= 9) {
          users.add({
            'id': row[0],
            'username': row[1],
            'password': row[2],
            'role': row[3],
            'name': row[4],
            'lastname': row[5],
            'Country': row[6],
            'Branch': row[7],
            'sex': row[8],
          });
        }
      }
      return users;
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }
Future<bool> login(String username, String password, BuildContext context) async {
  try {
    final users = await fetchUsers();
    final user = users.firstWhere(
      (user) => user['username'] == username && user['password'] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      final prefs = await getPrefsInstance();
      await prefs.setString(_prefKey, username);
      await prefs.setString(_userDataKey, jsonEncode({
        'id': user['id'],
        'username': user['username'],
        'password': user['password'],
        'role': user['role'],
        'name': user['name'],
        'lastname': user['lastname'],
        'Country': user['Country'],
        'Branch': user['Branch'],
        'sex': user['sex'], // Fixed: lowercase 's' to match fetchUsers()
      }));
      return true;
    } else {
      if (context.mounted) {
      print( 'Invalid username or password');
      }
      return false; // Explicit return
    }
  } catch (e) {
    if (context.mounted) {
      _showErrorDialog(context:context,message:  'An error occurred: $e');
    }
    return false; // Explicit return
  }
}

  Future<bool> isLoggedIn() async {
    final prefs = await getPrefsInstance();
    return prefs.getString(_prefKey) != null;
  }

  Future<String?> getCurrentUsername() async {
    final prefs = await getPrefsInstance();
    return prefs.getString(_prefKey);
  }

  Future<void> logout() async {
    final prefs = await getPrefsInstance();
    await prefs.remove(_prefKey);
    await prefs.remove(_userDataKey);
  }

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final prefs = await getPrefsInstance();
    final userString = prefs.getString(_userDataKey);
    if (userString == null) return null;
    return jsonDecode(userString);
  }

void _showErrorDialog({required BuildContext context, required String message}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFF2C2C2E),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 50, color: Color(0xffFF2057)),
            const SizedBox(height: 20),
            const Text(
              'Oops!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFF2057),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}